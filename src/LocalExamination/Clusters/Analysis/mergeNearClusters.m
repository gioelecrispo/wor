function [image, clusters] = mergeNearClusters(clusterIndex, image, clusters, options)
% mergeNearCluster è una funzione che preso in ingresso l'immagine image,
% la struttura clusters, e l'ID del cluster da studiare, cerca e controlla
% i cluster vicini: se soddisfano certe condizioni e possono essere
% considerati suoi "fratelli", li unisce secondo il concetto di
% fratellanza, creando un nuovo grande cluster. Infine, invalida i cluster
% componenti (i fratelli).

logger = getLogger(options); 
logger.debug('Merging cluster: %d', clusterIndex);

% DEFINIZIONE CODA-SET DI ESPLORAZIONE
% La struttura checkingClusterArray è una struttura che tiene conto di
% quali cluster sono stati scoperti ed esplorati. E' formato da due array:
%   1. container, tiene conto degli ID dei cluster aggiunti alla struttura
%   2. valid, che specifica se il cluster è stato esplorato già o meno.
% Come primo passo si aggiunge il cluster corrente.
checkingClusterArray = QueueSet();
checkingClusterArray.add(clusterIndex);

% DEFINIZIONE SET PIXELS E FALSE TRACE POINT
% Si definiscono dei PointsSet al fine di evitare, in questa fase, di
% aggiungere duplicati.
% - brotherhood_pixels, tiene conto dei pixels dei cluster componenti
%                       e dei pixels che li uniscono (anche se sono dei
%                       TRACE POINTS).
% - brotherhood_falseTracePoints, tiene conto dei false trace point dei
%                       cluster componenti, in modo tali da non ignorarli
%                       dopo il processo di creazione e analisi del nuovo
%                       cluster.
brotherhood_pixels = PointsSet();
brotherhood_falseTracePoints = PointsSet();


%%% CICLO DI ESPLORAZIONE
% Si ricercano tutti i cluster vicini che soddisfano le specifiche tramite
% la funzione findBrothers.
exitCondition = true;
while exitCondition
    
    % ID del cluster da studiare
    checkIndex = checkingClusterArray.head();
    
    % Se è vuoto abbiamo finito l'esplorazione, altrimenti esplorariamo e
    % aggiorniamo le strutture.
    if isempty(checkIndex) && checkingClusterArray.isInvalid()
        exitCondition = false;
    else
        [brothersIndexes, connectingPixels] = findBrothers(checkIndex, image, clusters, options);
        brotherhood_pixels.add(connectingPixels);
        checkingClusterArray.add(brothersIndexes);
    end
end


brothers = checkingClusterArray.container;
numBrothers = length(brothers);

%%% Clusters union
% We proceed to join the clusters, if numBrothers> = 2, ie if the
% structure contains the IDs of other clusters in addition to the cluster ID in
% exam.
if numBrothers >= 2
    
    %%% Getting new cluster
    [~, lengthClusters] = size(clusters);
    newClusterIndex = lengthClusters+1;
    
    %%% Joining pixels and False Trace Point of the brothers
    for i = 1 : numBrothers
        brotherhood_pixels.add(clusters(brothers(i)).pixels);
        brotherhood_falseTracePoints.add(clusters(brothers(i)).falseTracePoints);
        
        brotherFTP = clusters(brothers(i)).falseTracePoints;
        [lengthBrotherFTP, ~] = size(brotherFTP);
        for j = 1 : lengthBrotherFTP 
            image = setBelongingCluster(image, brotherFTP(j,:), newClusterIndex);
        end
    end
    
   
    %%% Deleting old clusters
    % All the clusters members of the brotherhood must be invalidated, 
    % being meaningless.
    for i = 1 : numBrothers
        clusters(brothers(i)).relationship = Brother(newClusterIndex);
        clusters(brothers(i)).processed = true;
        clusters(brothers(i)).delete = true;
    end
    
    
    
    
    
    
    %%% Updating info
    % We have to update the brotherhood FALSE TRACE POINT. In fact, besides
    % having to restore any FALSE TRACE POINT of the component clusters, we
    % have to add those found in the analysis phase (may differ, from
	% time that the TRACE POINT considered are dependent on the ANCHOR BP of
	% new clusters, which are in someway different).
    clusters(newClusterIndex).pixels = brotherhood_pixels.points;
    brotherhood_falseTracePoints.add(clusters(newClusterIndex).falseTracePoints);
    clusters(newClusterIndex).falseTracePoints = brotherhood_falseTracePoints.points;
    
    %%% Analysis of the new cluster
    % The new cluster formed by joining all the pixels belonging to the 
    % component clusters is added at the end of the "clusters" structure. 
    % At this point the analysis function calculates all the info of the
	% cluster. A post-processing phase is necessary to rejoin all info
	% from previous clusters.
    [image, clusters] = computeClusterInfo(newClusterIndex, image, clusters, options);
    
    brothersWithoutThis = num2str(brothers(1));
    for i = 2 : numBrothers
        if brothers(i) ~= clusterIndex
            brothersWithoutThis = [brothersWithoutThis ', ' num2str(brothers(i))];
        end
    end
    logger.debug('Cluster %d was merged with cluster: %s', clusterIndex, brothersWithoutThis);
end


end
    
