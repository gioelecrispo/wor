function [image, clusters] = processClusters(image, clusters, options)

%%%% TODO traduce

logger = getLogger(options);
logger.info('--> Processing clusters...')

%%%%% ORDINE DI RISOLUZIONE
% BROTHERHOOD  --->    si uniscono i cluster non risolvibili individualmente
%
% DISPARI      --->    si separano in pari e cluster di rango 3
% RANGO 1      --->    semplici e indipendenti
% PARI         --->    semplici, danno ulteriori info
% T-PATTERN    --->    semplici, creano END_POINT per i RETRACING
%
% ---- A questo punto sono rimasti solo clusters di rango 3
%
% RETRACING    --->    semplici da individuare, si hanno meno associazioni da fare per il BAD_SKEL
% BAD_SKEL     --->    ciclo di associazione, si cercano di associare tutti
% 3-GOOD_CONT  --->    se rimane qualcuno, va gestito con la buona continuità staccando un ramo
%
% ---- Se vi è stato almeno un cluster di 3 risolto tramite la
%      3-GOOD_CONT è necessario ripetere il ciclo di risoluzione
%      di cluster di rango 3
%%%%%

%%% ASSOCIAZIONE CLUSTER BROTHERHOOD
% Si cercano tutti i cluster che sono confusi per più di due rami. La
% confusione si verifica quando due rami di un cluster convergono in un
% altro cluster rendendo difficile propagare la decisione in modo corretto.
% Unendo i cluster in una BROTHERHOOD, si ottiene un cluster più grande e
% meno confuso.
%       __   __   __                       _________
%      /       \ /      becomes           |  BLACK  |----
%  ---o         o       ------->       ---|   BOX   |
%      \__   __/ \__                      |_________|----
%   bro 1     bro 2                       brotherhood
%
%%%%%
for clusterIndex = 1 : length(clusters)
    processed = clusters(clusterIndex).processed;
    if ~processed
        [image, clusters] = mergeNearClusters(clusterIndex, image, clusters, options);
    end
end

%%% RISOLUZIONE CLUSTER DISPARI - CLUSTER_RANK = 1
% I cluster di rango dispari pari a 1 sono frutto di una scheletonizzazione
% non precisa, e sono sempre del tipo:
%
% TIPO 1:
%     xxxxo       dove:  x  è un branch point (cluster)
%  --xxxxx               -  è un trace point
%     xxx                o  è un false trace point
%
% I false trace point (trace point collegati a 2 pixel dello stesso
% cluster) vanno considerati come cluster point e dunque si ha qui che il
% rango del cluster è pari a 1. Questo potrebbe accadere in situazioni di
% retracing con una cattiva sxheletonizzazione.
% oppure del tipo:
%
% TIPO 2:
%
%     xxxx       dove:   x  è un branch point (cluster)
%  --xxxxx               -  è un trace point
%     xxx
%
% e cioè senza false trace point.
% La risoluzione consiste nel verificare la presenza di false trace point:
%  - se esistono: si considera il cluster come rango 2 e si connette
%    tramite Dijkstra al false trace point più lontano.
%  - se non esistono: si tratta di un tratto particolare (ad esempio un
%    punto); si prende il pixel più distante dall'ingresso e si risolve con
%    come se fosse un cluster di rango 2 tramite un cammino hamiltoniano.
for clusterIndex = 1 : length(clusters)
    clusterRank = clusters(clusterIndex).clusterRank;
    processed = clusters(clusterIndex).processed;
    % Se è dispari, rango pari a 1 e non risolto
    %  --> trova i false trace point e risolvi in base a questo:
    %      se li ha Dijkstra; se non li ha Hamilton.
    if isOdd(clusterRank) && clusterRank == 1 && ~processed
        [image, clusters] = process1RankCluster(clusterIndex, image, clusters, options);
    end
end



%%% RISOLUZIONE CLUSTER PARI
% Si risolvono prima i cluster di rango pari.
%
%      2 |                   associazioni
%   1 ---o--- 4    ---->        [1  4]
%        | 3                    [2  3]
%
%%%%%
for clusterIndex = 1 : length(clusters)
    clusterRank = clusters(clusterIndex).clusterRank;
    processed = clusters(clusterIndex).processed;
    % Se è pari e non risolto
    %  --> risolvilo: Dijkstra/Hamilton, buona continuità
    if isEven(clusterRank) && ~processed
        [image, clusters] = processEvenRankCluster(clusterIndex, image, clusters, options);
    end
end



%%% RISOLUZIONE CLUSTER RANK 3 - T-PATTERN
% Come seconda procedura si risolvono quelli ri rango 3 che presentano una
% situazione T-pattern ben definita. I cluster di rango 3 che mostrano
% una situazione di T-pattern, vengono trasformati in cluster di rango 2
% più un cluster di rango 1 (visto come un END_POINT).
%
%  -----o-----                -----o-----                  o
%       |        correz.                                   |
%       |       -------->                      +           |
%       |       T-pattern                                  |
%   rango 3                     rango 2                   rango 1
%
%%%%%
for clusterIndex = 1 : length(clusters)
    clusterRank = clusters(clusterIndex).clusterRank;
    processed = clusters(clusterIndex).processed;
    % Se è di rango 3 e non risolto
    %   --> prova a vedere se è un T-PATTERN: se lo è stacca il ramo
    %       perpendicolare e risolvi il cluster risultante di 2 con Dijkstra
    if clusterRank == 3 && ~processed
        [image, clusters] = processTPatternCluster(clusterIndex, image, clusters, options);
    end
end



%%% RISOLUZIONE CLUSTER DISPARI - CLUSTER_RANK > 3
% I cluster di rango dispari, 5 o superiore, possono essere visti come
% cluster di rango 3 più un numero pari di rami che si accoppiano:
%
%     |                                           |
%   --o--     diventa       -----       +         |
%    / \     --------->                          / \
%  rango 5                 rango 2             rango 3
%
% Quindi, si ricercano i rami che si accoppiano e si definisce un nuovo
% cluster di rango 3 che va gestito opportunamente.
for clusterIndex = 1 : length(clusters)
    clusterRank = clusters(clusterIndex).clusterRank;
    processed = clusters(clusterIndex).processed;
    % Se è dispari, rango maggiore di 3 e non risolto
    %  --> trova i rami che si associano meglio per buona continuità e
    %      ottieni un cluster di 3 e un cluster di rango pari, che ne sono
    %      i figli e saranno risolti successivamente.
    if isOdd(clusterRank) && clusterRank > 3 && ~processed
        [image, clusters] = processOddRankCluster(clusterIndex, image, clusters, options);
    end
end




%%% ESEGUI IL CICLO DI RISOLUZIONE RANK 3
% Se vi è stato almeno un cluster di rank 3 risolto tramite parenthood, il
% ciclo deve essere rieseguito (potrebbero essere dei retracing, non visti
% precedentemente a causa di CLUSTER END POINT assenti).
processedClusters = cell2mat(retrieveStructureField(clusters, 'processed'));
toReprocess = find(processedClusters == false);
for cycle_rank3 = 1 : 1
%     if cycle_rank3 == 2
%         %%% RESET CLUSTER RANK 3
%         % Cancello i figli prodotti nell'iterazione precedente
%         children = [];
%         for npr3 = 1 : length(notProcessed_rank3)
%             clusterIndex = notProcessed_rank3(npr3);
%             children = [children, clusters(clusterIndex).relationship.children];
%         end
%         clusters(children) = [];
%         
%         % Azzero relationship e processed flag
%         for tp = 1 : length(toReprocess)
%             clusterIndex = toReprocess(tp);
%             clusters(clusterIndex).relationship = [];
%             clusters(clusterIndex).delete = false;
%             clusters(clusterIndex).processed = false;
%         end
%         
%         % Ripristino retracing points
%         retracingPoints = image.retracingPoints.points;
%         [lengthRetracingPoints, ~] = size(retracingPoints);
%         image.retracingPoints.clear();
%         for rp = 1 : lengthRetracingPoints
%             possibleDirections = analyzeNeighbors(retracingPoints(rp,:), image);
%             [lengthPossibleDirections, ~] = size(possibleDirections);
%             if lengthPossibleDirections
%                 image.toolMatrix(retracingPoints(rp,1), retracingPoints(rp,2)) = PointType.CLUSTER_END_POINT;
%             else
%                 image.toolMatrix(retracingPoints(rp,1), retracingPoints(rp,2)) = PointType.END_POINT;
%             end
%         end
%     end
    
    
    %%% RISOLUZIONE CLUSTER RANK 3 - RETRACING
    % I cluster di rango 3 vicini ad un segmento dritto connesso ad un
    % END_POINT e con l'angolo opposto minore di una certa soglia viene
    % classificato come RETRACING:
    %
    %        x             dove x è un END_POINT
    %        |
    %        |  3          l'angolo compreso tra 1 e 2 è inferiore ad
    %       -o-            una certa soglia e il segmento uscente da 3
    %   1  /   \  2        è dritto entro certi limiti.
    %     /     \
    %
    %%%%%
    for clusterIndex = 1 : length(clusters)
        clusterRank = clusters(clusterIndex).clusterRank;
        processed = clusters(clusterIndex).processed;
        % Se è di rango 3 e non risolto
        %  --> prova a vedere se è un RETRACING: se lo è, risolvilo
        if clusterRank == 3 && ~processed
            [image, clusters] = processRetracingCluster(clusterIndex, image, clusters, options);
        end
    end
    
    
    %%% RISOLUZIONE CLUSTER RANK 3 - CICLO MARRIED
    % association = [ownIndex indexesCluster goodContinuityRank pxDistances associatedBPIndexes]
    % 1. index del cluster che si sta analizzando;
    % 2. index del cluster connesso al primo;
    % 3. valore della buona continuità tra i due cluster nel range [0 - 180] --> (0 is better);
    % 4. distanza in px tra i due cluster;
    % 5. sharedBPIndex(1): index dell'AnchorBP del primo cluster che si connette al secondo
    % 6. sharedBPIndex(2): index dell'AnchorBP del secondo cluster che si connette al primo
    %
    %   \                  /          1  \   3            1    / 2
    %    \________________/               o ---          --- o
    %    /     pxdist     \           2  /       shared        \ 3
    %   /                  \                    BP index
    %
    %%%%%
    maxImageDim = max(image.dimensions);
    endResolution = false;
    while ~endResolution
        associationMatrix = [];
        for clusterIndex = 1 : length(clusters)
            clusterRank = clusters(clusterIndex).clusterRank;
            processed = clusters(clusterIndex).processed;
            % Se è di rango 3 e non è stato risolto
            %  --> computa le possibili associazioni con altri cluster di rango
            %      3; crea una matrice di associazione per tutti i cluster di
            %      rango 3 studiati; i migliori 2 per buona continuità verrano
            %      selezionati e connessi.
            if clusterRank == 3 && ~processed
                [image, clusters, association] = processMarriedCluster(clusterIndex, image, clusters, options);
                if ~isempty(association)
                    associationMatrix = [associationMatrix; association];
                end
            end
        end
        if ~isempty(associationMatrix)
            % CANCELLO RIGHE CON ASSOCIAZIONI IMPROBABILI
            % Cancello tutte le associazioni la cui lunghezza in termini di pixels
            % supera la soglia prestabilita da Thresholds.BAD_SKEL_MAX_SEGMENT_LENGTH*maxImageDim
            %associationMatrix(associationMatrix(:,4) > floor(Thresholds.MARRIED_MAX_SEGMENT_LENGTH*maxImageDim), :) = [];
            %associationMatrix(associationMatrix(:,3) > floor(Thresholds.MARRIED_MAX_GOOD_CONTINUITY_DEGREE), :) = [];
            % OTTENGO LE RIGHE MIGLIORI
            % Cerco nella matrice le associazioni che hanno il valore di buona
            % continuità migliore, e scelgo le associazioni con un numero minore di
            % px sul segmento congiungente (situazione più probabile - soprattuto
            % in uno scheletro ideale, perfetto).
            betterGCAssociations = associationMatrix(find(associationMatrix(:,3) == min(associationMatrix(:,3))),:);
            if ~isempty(betterGCAssociations)
                %[~, minIndex] = min(associationMatrix(:,3));  % cerco il minimo sulla buona continuità
                %selected = associationMatrix(minIndex, :);
                [~, minIndex] = min(betterGCAssociations(:,4));
                selectedAssociation = betterGCAssociations(minIndex, :);
                connCluster1 = selectedAssociation(1);
                connCluster2 = selectedAssociation(2);
                sharedIndexes = selectedAssociation(5:6);
                connectedIndexes = [selectedAssociation(7:8); selectedAssociation(9:10)];
                clusters = createMarriedClusterAssociation(connCluster1, connCluster2, sharedIndexes, connectedIndexes, clusters);
            else
                endResolution = true;
            end
        else
            endResolution = true;
        end
    end
    
    %%% ANALISI RISOLUZIONE CLUSTER:
    % Se qualche cluster di rango 3 non è stato ancora risolto, verrà risolto
    % secondo la regola più generale della buona continuità, che divide il
    % cluster di rango 3 in due figli: uno di rango 2 e uno di rango 1. Dato
    % che questl'ultimo rappresenta un END_POINT, è necessario ripetere
    % l'analisi sui cluster di rango 3, dal momento che qualche associazione
    % potrebbe essere errata / ci potrebbe essere qualche RETRACING non
    % considerato precedentemente.
    processedClusters = cell2mat(retrieveStructureField(clusters, 'processed'));
    notProcessed_rank3 = find(processedClusters == false);
    
    %%% RISOLUZIONE CLUSTER RANK 3 - 3-GOOD_CONT
    % Un cluster di rango 3 non risolto, può essere visto come un aggregato di
    % due clusters: uno di rango 1 (che è come un END_POINT) e un cluster di
    % rango 2.
    %
    %
    %    --o--       diventa       --o--       +         o
    %       \       --------->                            \
    %   rango 3                   rango 2             rango 1
    % non risolto
    %
    %%%%%
    for clusterIndex = 1 : length(clusters)
        clusterRank = clusters(clusterIndex).clusterRank;
        processed = clusters(clusterIndex).processed;
        % Se è di rango 3 e non è stato risolto
        %   !!! vuol dire che non è un T-PATTERN, né un RETRACING, nè si può
        %       connettere con altri cluster di rango 3 (CONNECTING CLUSTER).
        %   --> stacca il ramo che ha un valore di buona continuità più basso e
        %       risolvi il cluster risultante di 2 con Dijkstra
        if clusterRank == 3 && ~processed
            [image, clusters] = processGC3RankCluster(clusterIndex, image, clusters, options);
        end
    end
    
    if isempty(notProcessed_rank3)
        break;
    end
end




%%% CHECK RESOLUTION OF ALL THE CLUSTERS
% Check the resolution of the clusters: if they have not all been resolved,
% throw an error.
processedClusters = cell2mat(retrieveStructureField(clusters, 'processed'));
notProcessed = find(processedClusters == false);
if ~isempty(notProcessed)
    logger.error('PROCESS_CLUSTERS_ERROR: not all the clusters have been processed!')
    logger.debug('Cluster not processed: %d', notProcessed');
    error('PROCESS_CLUSTERS_ERROR: not all the clusters have been processed!')
end


%%%%% DEBUG CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% TROVA DELETED E CLUSTER RANK
if options.debug == true
    deletedClusters = cell2mat(retrieveStructureField(clusters, 'delete'));
    deletedClusters = find(deletedClusters == true);
    clusterRankClusters = cell2mat(retrieveStructureField(clusters, 'clusterRank'));

    if ~isempty(deletedClusters)
        deletedClusterStr = num2str(deletedClusters(1));
        for i = 2 : length(deletedClusters)
            deletedClusterStr = [deletedClusterStr ', ' num2str(deletedClusters(i))];
        end
        logger.debug('Deleted clusters: %s', deletedClusterStr);
    end

    %%% FIND WEDDING
    relationshipClusters = retrieveStructureField(clusters, 'relationship');
    weddingCluster = false(1, length(relationshipClusters));
    for i = 1 : length(relationshipClusters)
        weddingCluster(i) = isa(relationshipClusters{i}, 'Wedding');
    end
    weddingClusterIndexes = find(weddingCluster == true);
    if ~isempty(weddingClusterIndexes)
        weddingClusterIndexesStr = num2str(weddingClusterIndexes(1));
        for i = 2 : length(weddingClusterIndexes)
            weddingClusterIndexesStr = [weddingClusterIndexesStr ', ' num2str(weddingClusterIndexes(i))];
        end
        logger.debug('Married clusters: %s', weddingClusterIndexesStr);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end