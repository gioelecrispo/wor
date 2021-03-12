function [image, clusters] = correctSkeletonErrors(image, clusters, options)

logger = getLogger(options);
logger.info('--> Correcting skeleton...')

%%% DESCRIZIONE SKELETON CORRECTIONS
% Tra gli skeleton errors abbiamo quelli che si manifestano quando si ha
% una traiettoria non perfettamente connessa (L-PIVOT, 2_ANCHORBP_SAME_POINT,
% etc) che vengono risolti con l'introduzione dei FALSE_TRACE_POINT
% all'interno dei cluster. 
% Le correzioni da fare sono dunque le seguenti: 
%   - BAD_SKEL_I, quando il processo di scheeletonizzazione crea una sorta
%     di I tra due linee che nell'immagine originale erano molto vicine. La
%     grandezza del segmento dipende dalla risoluzione, per cui potrebbe
%     essere necessario cambiare la soglia 
%     Thresholds.BAD_SKEL_I_MAX_SEGMENT_LENGTH.
%   - 3_CONNECTED_3, errori dovuti ad una cattiva scheletonizzazione, che
%     produce 2 cluster di rango 3 connessi tra di loro tramite due rami.
%     Questi cluster non danno informazione (se non il fatto che
%     nell'immagine originale vi erano due linee molto vicine che non sono
%     state skeletonizzate bene, per cui si preferisce eliminare i due rami
%     e unire i cluster tramite una retta. I cluster vengono dunque
%     eliminati. [c'è da perfezionare il criterio di detection]
%   - PATTERN_4_RANK_2_ANCHORBP, che sono degli errori dell scheletro
%     che creano dei cluster di rango 4 con soli 2 AnchorBP (e il cluster è
%     formato solo da tali 2 pixels). In questi casi, non è sempre semplice
%     risolvere il clusters, perché potrebbe essere vicino ad altri clusters, 
%     per cui conviene staccare i due pixel, in modo tale da non creare
%     buchi nella traiettoria ma elimando il cluster. Sebbene vi sia un
%     errore di 2 px, la pratica è ammissibile, dal momento che velocizza
%     il programma e lo semplifica nella risoluzione dei cluster.
%
% Tra di queste, le prime due sono dovute ad una scheletonizzazione non
% perfetta e vanno dunque risolte prima dell'esecuzione di questo
% algoritmo. Dato che ci concentriamo sullo scheletro ideale, sono
% disattivate.

%%% ORDINE SKELETON CORRECTIONS
%  - 4_RANK_2_ANCHORBP: perché si eliminano cluster ambigui e questo
%                       permette una migliore correzione degli altri errori
%  - 3_CONNECTED_3:    per lo stesso motivo del precedente
%  - BAD_SKEL_I



PATTERN_L_PIVOT              = false;      % NON SERVE
PATTERN_2_EXIT_DIRECTIONS    = false;      % NON SERVE
PATTERN_4_RANK_2_ANCHORBP    = true;
PATTERN_3_CONNECTED_3        = false;
PATTERN_BAD_SKEL_I           = false;


%%% RIDUZIONE CLUSTERS
% Alcuni cluster di BP sono dei casi particolari:
%  - CLUSTER con pattern L-PIVOT,
%        cioè quei gruppi di due BP che sono frutto di una cattiva
%        scheletrizzazione e che non pongono dinanzi a nessuna scelta.
%         ______               ______               ______
%        | x    |   cluster   |      |   correz.   | x    |
%        |  xx  |    ---->    |  xx  |    ---->    |  xo  |    dove o si
%        |   x  |             |   x  |             |   x  |    cancella
%        |    x |             |      |             |    x |
%        |______|             |______|             |______|
%
%  - CLUSTER con pattern 3-CONNECTED-3
%        cioè quei clusters di rango 3 che hanno 2 rami in comune, cioè
%        tali che si connettono uno all'altro tramite due rami (e non hanno
%        altri elementi, altri cluster ad esempio, tra di loro). La
%        correzione prevede di eliminare i rami in comune e riconnetterli
%        tramite un segmento 8-connesso che collega direttamente i rami
%        rimasti.
%             ____
%          __/    \___     correz.       ___________
%            \____/       -------->
%
%  - CLUSTER con pattern 2 EXIT DIRECTION,
%        cioè quei clusters che hanno solo due direzioni di uscita;
%        per cui non ha senso trattarlo come un insieme di branch point e
%        conviene "correggere" il cluster eliminando i pixel superflui. Per
%        farlo ci aiutiamo con l'algoritmo di dijkstra, che selezionerà il
%        percorso minimo.
%          ___________
%         |           |    x  indica i branchPoint
%         |  oxxxx    |    o  indica il pixel di tipo TRACE_POINT
%         |    xxxxo  |
%         |___________|
%
%  - CLUSTER con pattern BADSKEL_I
%        cioè quei clusters di rango 3 che sono frutto del processo di
%        scheletonizzazione, quando si hanno 2 linee troppo vicine tra loro.
%        Si verifica su 2 cluster di rango 3 uniti da un segmento corto e 
%        più o meno dritto.
%          _____________                            _____________ 
%         /   |         \_____      correz.        /             \_____ 
%         \___|_________/          -------->       \_____________/    
%
%  - CLUSTER con pattern 4_RANK_2_ANCHORBP
%        cioè quei cluster di rango 4 che hanno solo 2 pixels posizionati
%        in maniera obliqua e sono AnchorBP. Ciascuno ha due possibili
%        direzioni, da cui nascono linee che si toccano ma non si
%        intrecciano (di fatto quindi non dovrebbe essere un cluster). La
%        sua risoluzione consiste nel distruggere il cluster, staccando i
%        due punti in modo tale da non creare buchi nella traiettoria. 
%               x  x                 x  x                  x  x
%               x x      prob.       - x      correz.     x  x
%             xx x      ------>    xx -      -------->   xx  x
%                 x                    x                     x
%%%

%%% RISOLUZIONE ERRORI
% Cerco patterns: L-PIVOT
% (o indica il pivot e x i branchPoint)
%    xo         ox          x           x
%     x         x          xo           ox
% UP_RIGHT   UP_LEFT   DOWN_RIGH    DOWN_LEFT
if PATTERN_L_PIVOT
    logger.info('Correcting L-Pivot Patterns.');
    modifiedLPivot = false;
    for clusterIndex = 1 : length(clusters)
        logger.debug('Analyzing cluster: %d', clusterIndex);
        [image, modified] = correctSkeletonErrors_LPivot(clusterIndex, image, clusters);
        if modified == true
            modifiedLPivot = true;
        end
    end
    % Se ho fatto modifiche, rigenero le toolMatrix, branchPointMatrix e i clusters
    if modifiedLPivot == true
        image = analyzeImage(image, options);
        [image, clusters] = detectCluster(image, options);
    end
end




% Cerco patterns: 4 RANK 2 ANCHOR BP
% Verifico cluster di rango 4 che hanno due paia di anchor BP che puntano
% allo stesso pixel: li sposto nell'altra unica direzione possibile (al
% punto da non fare buchi) in modo tale da disconnettere il cluster e avere
% una semplificazione dello scheletro.
%
%      x  x               x  x                  x  x
%      x x      prob.     - x      correz.     x  x
%    xx x      ------>  xx -      -------->   xx  x
%       x                  x                     x
%
if PATTERN_4_RANK_2_ANCHORBP
    logger.info('Correcting 4-rank cluster with only 2 Anchor-Branch-Point Patterns.');
    modified4Rank2AnchorBP = false;
    for clusterIndex = 1 : length(clusters)
        logger.debug('Analyzing cluster: %d', clusterIndex);
        [image, clusters, modified] = correctSkeletonErrors_4Rank2AnchorBP(clusterIndex, image, clusters);
        if modified == true
            modified4Rank2AnchorBP = true;
        end
    end
    % Se ho fatto modifiche, rigenero le toolMatrix, branchPointMatrix e i clusters
    if modified4Rank2AnchorBP
        image = analyzeImage(image, options);
        [image, clusters] = detectCluster(image, options);
    end
end





% Cerco patterns: 3-CONNECTED-3
% Verifico cluster di rango 3 che hanno 2 uscite in un altro cluster di
% rango 3, che è lo stesso.
%     ____
%  __/    \___     correz.       ___________
%    \____/       -------->
%
if PATTERN_3_CONNECTED_3
    logger.info('Correcting 3-to-3 Patterns.');
    modified3connected3 = false;
    for clusterIndex = 1 : length(clusters)
        logger.debug('Analyzing cluster: %d', clusterIndex);
        clusterRank = clusters(clusterIndex).clusterRank;
        delete = clusters(clusterIndex).delete;
        if clusterRank == 3 && delete == false
            [image, clusters, modified] = correctSkeletonErrors_3Connected3(clusterIndex, image, clusters);
        end
        if modified == true
            modified3connected3 = true;
        end
    end
    % Se ho fatto modifiche, rigenero le toolMatrix, branchPointMatrix e i clusters
    if modified3connected3 == true
        image = analyzeImage(image, options);
        [image, clusters] = detectCluster(image, options);
    end
end




% Cerco patterns : BAD_SKEL_I
% Verifico la presenza di I tra due linee molto vicine. Si verifica su 2
% cluster di rango 3 uniti da un segmento corto e più o meno dritto.
%    _____________                               _____________ 
%   /   |         \_____      correz.           /             \_____ 
%   \___|_________/          -------->          \_____________/    
%
if PATTERN_BAD_SKEL_I
    logger.info('Correcting Bad-Skeletonization with I form Patterns.');
    modifiedBadSkelI = false;
    for clusterIndex = 1 : length(clusters)
        logger.debug('Analyzing cluster: %d', clusterIndex);
        clusterRank = clusters(clusterIndex).clusterRank;
        if clusterRank == 3
            [image, clusters, modified] = correctSkeletonErrors_BadSkelI(clusterIndex, image, clusters);
            if modified == true
                modifiedBadSkelI = true;
            end
        end
    end
    % Se ho fatto modifiche, rigenero le toolMatrix, branchPointMatrix e i clusters
    if modifiedBadSkelI == true
        image = analyzeImage(image, options);
        [image, clusters] = detectCluster(image, options);
    end
end









% Cerco patterns: 2 EXIT DIRECTIONS
% Verifico la presenza di cluster con 2 punti di uscita, con un angolo non
% superiore a 90 gradi.
%   ___________
%  |           |    x  indica i branchPoint
%  |  oxxxx    |    o  indica il pixel di tipo TRACE
%  |    xxxxo  |
%  |___________|
%
if PATTERN_2_EXIT_DIRECTIONS
    logger.info('Correcting Clusters with only 2 Exit Directions Patterns.');
    modified2ExitDirections = false;
    for clusterIndex = 1 : length(clusters)
        logger.debug('Analyzing cluster: %d', clusterIndex);
        clusterRank = clusters(clusterIndex).clusterRank;
        if clusterRank == 2
            externalAngles = clusters(clusterIndex).externalAngles;
            externalAngles(1) = mod(externalAngles(1)+180, 360); % Si contrappone l'angolo per analizzarne la differenza
            anglediff = angdiffd(externalAngles(1), externalAngles(2));
            if anglediff < 90
                [image, clusters] =  correctSkeletonErrors_2ExitDirections(clusterIndex, image, clusters);
                modified2ExitDirections  = true;
            end
        end
    end
    % Se ho fatto modifiche, rigenero le toolMatrix, branchPointMatrix e i clusters
    if modified2ExitDirections == true
        image = analyzeImage(image, options);
        [image, clusters] = detectCluster(image, options);
    end
end



end