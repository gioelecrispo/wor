function [m_crp, statistics] = clusterResolutionMeasure(image, clusters, options, online8conn)
% La funzione calcola la percentuale di cluster risolti correttamente.
% Essa dunque prende in ingresso la lista di cluster e l'array ordinato di
% coordinate [x, y] della traiettoria online.
% Un cluster è risolto correttamente se dato il suo rango (e quindi il
% numero di exit directions) esse conducono ad un percorso che trova
% riscontro nella traiettoria online.

logger = getLogger(options);

%%% OTTENGO TRAIETTORIA DALLA ONLINE_8CONN
% Costruisco la traiettoria attraverso i dati online (la 8-connessa).
x = online8conn.x_8c';
y = online8conn.y_8c';
traj = [y, x];

%%% CLUSTER
% Vengono presi i TRACE POINT immediatamente successivi agli ANCHOR BRANCH
% POINT; ad essi viene dato l'identificativo relativo all'anchorBP a cui
% appartengono.
%
%      1  ___________  3
%  ----- |           | ------
%        |  CLUSTER  |
%      2 |           | 4
%  ----- |___________| ------
%
%
%%% METODO
% Il metodo per vedere se un cluster è stato risolto correttamente consiste
% nel verificare che la traiettoria online 8-connessa passi nell'ordine
% definito nel campo pairedIndexes contenuto nei clusters.
% Il campo pairedIndexes, infatti, definisce come si accoppiano le exit
% directions.
% In linea teorica, un TRACE POINT dovrebbe essere attraversato solo una
% volta, tranne nei casi di RETRACING e CONNECTED_CLUSTERS (MARRIED), dove
% è necessario ripassare per un dato ramo per avere il corretto pairing.
% Per evitare spiacevoli ambiguità, si computa la grandezza del cluster in
% termini di pixels, e la usa per discernere percorsi che sarebbe troppo
% lunghi e che non attraverserebbero il cluster.
%%%%%

%%% INIZIALIZZO INDEXES SET
% Set per registrare gli indici di cluster deleted, fratelli di Brotherhood
% padri di Parenthood, coniugi di Wedding.
deletedIndexes = IndexesSet();
parenthoodIndexes = IndexesSet();
brotherhoodIndexes = IndexesSet();
marriedIndexes = IndexesSet();

%%% CICLO CONTROLLO CLUSTER ASSOCIATION
% Si analizzano tutti i clusters: quelli eliminati sono figli di parenthood
% o fratelli di brotherhood.
% Per quelli non eliminati, va fatta una distinzione importante:
%  - RETRACING: va duplicato il TRACE_POINT di retracing (se quest'ultimo è
%               anche un RETRACING_POINT).
%  - UNIQUE: cluster di rango 1; fare il pairing del cluster è difficile.
%            Si duplica il TRACE_POINT esterno all'anchor branch point.
%%%%%
[~, lengthClusters] = size(clusters);
correctResolvedCluster = false(1, lengthClusters);
for clusterIndex = 1 : lengthClusters
    
    if clusterIndex == 72
        disp('')
    end
    
    deleted = clusters(clusterIndex).delete;
    relationship = clusters(clusterIndex).relationship;
    
    %%% DISTINZIONE SUL FLAG DELETE
    % Se un cluster ha il flag 'delete = true' vuol dire che è un father
    % (di una brotherhood) oppure un brother (un componente di una
    % brotherhood).
    if deleted == false
        
        %%% CONTROLLO WEDDING
        if isa(relationship, 'Wedding')
            marriedIndexes.add([clusterIndex, relationship.connectedCluster]);
        end
        
        %%% CALCOLO NUMERO PIXELS DEL CLUSTER
        pixels = clusters(clusterIndex).pixels;
        falseTracePoints = clusters(clusterIndex).falseTracePoints;
        clusterPoints = [pixels; falseTracePoints];
        [lengthClusterPoints, ~] = size(clusterPoints);
        
        %%% OTTENGO EXIT TRACE POINT
        anchorBP = clusters(clusterIndex).anchorBP;
        exitDirections = clusters(clusterIndex).exitDirections;
        clusterRank = clusters(clusterIndex).clusterRank;
        exitTracePoint = zeros(clusterRank, 2);
        for i = 1 : clusterRank
            exitTracePoint(i,:) = anchorBP(i,:) + exitDirections(i,:);
        end
        
        
        %%% OTTENGO LE COINCIDENCES
        % Ad ogni EXIT TRACE POINT viene assegnato un ID numerico; nella
        % traiettoria online 8-connessa vengono cercati i punti che uguali
        % agli EXIT TRACE POINT e viene ottenuto un vettore di
        % "coincidences". Tale vettore, ordinato, indica quando e come si
        % attraversa un cluster. Dal campo relationship del cluster si
        % ottengono i "pairedIndexes", tramite cui controllare la corretta
        % associazione. In pratica, se il vettore coincidences contiene i
        % pairedIndexes, si può dire che il cluster è risolto (tutte le
        % associazioni fatte correttamente).
        % Per i cluster di rango dispari problematici inserisco dei
        % duplicati.
        coincidences = [];
        for i = 1 : clusterRank
            ind = find(traj(:,1) == exitTracePoint(i,1) & traj(:,2) == exitTracePoint(i,2));
            anchorBP_ind = ones(length(ind), 1)*i;
            coincidences = [coincidences; ind, anchorBP_ind];
            % Duplico se è un RETRACING POINT
            if length(ind) == 1 && isRetracingPoint(image, exitTracePoint(i,:)) %image.toolMatrix(exitTracePoint(i,1), exitTracePoint(i,2)) == PointType.RETRACING_POINT
                coincidences = [coincidences; ind, anchorBP_ind];
            end
        end
        [lengthCoincidences, ~] = size(coincidences);
        [~, sortingOrder] = sort(coincidences(:,1));
        coincidences = coincidences(sortingOrder,:);
        
        
        
        %%% CALCOLO LUNGHEZZA COINCIDENCES
        % Numero di coincidences che dovrebbe avere un cluster.
        lc = ceil(clusterRank/2) * 2;
        
        %%% INSERIMENTO DUPLICATI
        % Controllo se il cluster è di rango 1, cioè è un "Unique".
        if lengthCoincidences < lc
            if isa(relationship, 'Unique')
                coincidences = [coincidences; coincidences];
            end
        end
        
        %%% RIMOZIONE DUPLICATI
        % I cluster di tipo "Single" non possono avere un numero dispari di
        % coincidences e quindi deve essere rimosso l'indice "spurio".
        if lengthCoincidences > lc
            if isa(relationship, 'Single')
                repValCondition = true;
                while repValCondition
                    [lengthCoincidences, ~] = size(coincidences);
                    [~, repeatedTracePoints, ~] = findDuplicatesValues(coincidences(:,2));
                    if isempty(repeatedTracePoints)
                        break;
                    end
                    
                    numRepeatedTP = length(repeatedTracePoints);
                    repIndexes = false(lengthCoincidences, 1);
                    for i = 1 : numRepeatedTP
                        repIndexes = repIndexes | (coincidences(:,2) == repeatedTracePoints(i));
                    end
                    coincidencesID = 1 : lengthCoincidences;
                    indexes = coincidencesID(repIndexes);
                    
                    if numRepeatedTP > 1
                        % Rimuovi le coppie già presenti
                        reshapedCoincidences = zeros(numRepeatedTP, 2);
                        for i = 1 : length(indexes)/2
                            ind = i*2;
                            index1 = indexes(ind-1);
                            index2 = indexes(ind);
                            reshapedCoincidences(i,:) = [coincidences(index1,2), coincidences(index2,2)];
                        end
                        regist = [];
                        for i = 1 : numRepeatedTP
                            for j = i+1 : numRepeatedTP
                                if isTheSameCombination(reshapedCoincidences(i,:), reshapedCoincidences(j,:))
                                    regist = [regist, i];
                                end
                            end
                        end
                        if isempty(regist)
                            regist = [1 3]; 
                        end
                        repeatedIndexesToDelete = [];
                        for i = 1 : length(regist)
                            repeatedIndexesToDelete = [repeatedIndexesToDelete, regist(i), regist(i)+1];
                        end
                    else
                        if diff(indexes) == 1
                            % sono consecutivi - rimuovi quello dispari
                            repeatedIndexesToDelete = isOdd(indexes);
                        else
                            pxDist(1) = abs(coincidences(indexes(1),1) - coincidences(indexes(1)+1,1));
                            pxDist(2) = abs(coincidences(indexes(2),1) - coincidences(indexes(2)-1,1));
                            if pxDist(1) > pxDist(2)
                                repeatedIndexesToDelete = indexes == indexes(1);
                            else
                                repeatedIndexesToDelete = indexes == indexes(2);
                            end
                        end
                    end
                    indexes = indexes(repeatedIndexesToDelete);
                    coincidences(indexes,:) = [];
                end
            end
        end
        
        [lengthCoincidences, ~] = size(coincidences);
        
        
        %%% OTTENGO IL PAIRING DEL CLUSTER
        pairedIndexes = relationship.pairedIndexes;
        
        
        %%% CONTROLLO COINCIDENCES
        % maxPxDist definisce il numero massimo di pixel di distanza tra
        % due trace point nella traiettoria online. Il numero è calcolato
        % in questo modo: si prende il numero di px del cluster e lo si
        % incrementa di un 20% (supponendo che nella traiettoria online,
        % oltre a coprire tutti i px del cluster si possa ripassare per
        % alcuni punti) e si aggiunge 2 (distanza del trace point
        % dall'anchorBP * 2).
        maxPxDist = round(lengthClusterPoints*3) + 2;
        if lengthCoincidences == lc
            correctPairing = false(1, lengthCoincidences/2);
            for i = 1 : lengthCoincidences/2
                index = (i*2);
                pxDist =  coincidences(index,1) - coincidences(index-1,1);
                if pxDist <= maxPxDist
                    pair = [coincidences(index-1,2) coincidences(index,2)];
                    [lengthPairedIndexes, ~] = size(pairedIndexes);
                    bool = false;
                    for k = 1 : lengthPairedIndexes
                        if isTheSameCombination(pair, pairedIndexes(k,:))
                            bool = true;
                            break;
                        end
                    end
                    correctPairing(i) = bool;
                end
            end
            res = find(correctPairing == false, 1);
            if isempty(res)
                correctResolvedCluster(clusterIndex) = true;
            end
        else
            logger.warn('CLUSTER_RESOLUTION_MEASURE: BAD PAIRING. Odd lenghtCoincidences')
        end
    else
        if isa(relationship, 'Brother')
            deletedIndexes.add(clusterIndex);
            brotherhoodIndexes.add(clusterIndex);
        elseif isa(relationship, 'Parenthood')
            parenthoodIndexes.add([clusterIndex, relationship.children]);
        end
        correctResolvedCluster(clusterIndex) = true;
    end
end




%%% VERIFICO PARENTHOODS
% Per dire che una parenthood è stata risolta correttamente, entrambi i
% figli devono essere stati associati correttamente.
lengthParenthoodIndexes = length(parenthoodIndexes);
for i = 1 : lengthParenthoodIndexes
    fatherIndex = parenthoodIndexes.indexes(i,1);
    childIndex_1 = parenthoodIndexes.indexes(i,2);
    childIndex_2 = parenthoodIndexes.indexes(i,3);
    deletedIndexes.add(childIndex_1);
    deletedIndexes.add(childIndex_2);
    if correctResolvedCluster(childIndex_1) == true && correctResolvedCluster(childIndex_2) == true
        correctResolvedCluster(fatherIndex) = true;
    else
        correctResolvedCluster(fatherIndex) = false;
    end
end

%%% COMPUTO PERCENTUALE DI CLUSTER RISOLTI CORRETTAMENTE
% Cancello il risultato dei cluster cancellati e calcolo la percentuale su
% questo numero.
validIndexes = true(1, lengthClusters);
validIndexes(deletedIndexes.indexes) = false;
notResolved = find(correctResolvedCluster == false);
filteredCRC = correctResolvedCluster(validIndexes);
logger.info('Correctly solved clusters:  %d  on  %d.', sum(filteredCRC == true), length(filteredCRC));
    if ~isempty(notResolved)
    notResolvedStr = num2str(notResolved(1));
    for i = 2: length(notResolved)
        notResolvedStr = [notResolvedStr ', ' num2str(notResolved(i))];
    end
    logger.debug('Not solved clusters: %s', notResolvedStr);
end

if ~isempty(filteredCRC)
    m_crp = sum(filteredCRC == true) / length(filteredCRC);
else
    m_crp = 1;
end


%%% CALCOLO STATISTICHE DEI CLUSTER
statistics = [];
statsCounter = 1;
for clusterIndex = 1 : lengthClusters
    if validIndexes(clusterIndex) == true
        clusterRank = clusters(clusterIndex).clusterRank;
        resolvedValue = double(correctResolvedCluster(clusterIndex));
        statistics(statsCounter).clusterRank = clusterRank;
        statistics(statsCounter).resolved = resolvedValue;
        statsCounter = statsCounter + 1;
    end
end


end