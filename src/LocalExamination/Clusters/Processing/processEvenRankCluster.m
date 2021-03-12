function [image, clusters] = processEvenRankCluster(clusterIndex, image, clusters, options)

logger = getLogger(options);
logger.info('Processing even-rank cluster: %d', clusterIndex);

pixels = clusters(clusterIndex).pixels;
falseTracePoints = clusters(clusterIndex).falseTracePoints;
clusterPoints = [pixels; falseTracePoints];
anchorBP = clusters(clusterIndex).anchorBP;
exitDirections = clusters(clusterIndex).exitDirections;
clusterRank =  clusters(clusterIndex).clusterRank;
externalAngles =  clusters(clusterIndex).externalAngles;
internalAnglesFrom0 =  clusters(clusterIndex).internalAnglesFrom0;


% Se il clusterRank = 2 allora la risoluzione del cluster è banale: non
% bisogna fare alcuna scelta, da un punto di ancoraggio si va all'altro.
% Ciononostante, è necessario fare delle ipotesi sull'angolo di
% ingresso/uscita: se la loro differenza è maggiore di 90 gradi, la
% risoluzione del cluster verte sull'utilizzo di un cammino hamiltoniano;
% altrimenti l'algoritmo di dijkstra può essere utilizzato per trovare il
% cammino minimo.
if clusterRank == 0
    % Correggi il cluster con Dijkstra
    % Il cluster verrà eliminato: Dijkstra produrrà una traiettoria
    % 8-connessa perfetta.
    [image, clusters] = correctSkeletonErrors_2ExitDirections(clusterIndex, image, clusters, options);
    return;
elseif clusterRank == 2 
    externalAngles(1) = mod(externalAngles(1)+180, 360); % Si contrappone l'angolo per analizzarne la differenza
    anglediff = angdiffd(externalAngles(1), externalAngles(2));
    if anglediff < 90
        [paths{1}, clusters] = retrievePathFromDijkstra(clusterIndex, clusters, anchorBP(1,:), anchorBP(2,:));
    else
        % Trovo il cluster point più distante dall'anchorBP 1
        clusterPointsWithoutAnchorBP = deleteAnchorBPFromCluster(clusterPoints, anchorBP);
        if ~isempty(clusterPointsWithoutAnchorBP )
            point = anchorBP(1,:);
            distancesFromAnchorBP = computeDistancesFromPoint(point, clusterPointsWithoutAnchorBP);
            [~, maxIndex] = max(distancesFromAnchorBP);
            farestPoint = clusterPointsWithoutAnchorBP(maxIndex,:);
            [partialPath_1, clusters] = retrievePathFromDijkstra(clusterIndex, clusters, anchorBP(1,:), farestPoint);
            [partialPath_2, clusters] = retrievePathFromDijkstra(clusterIndex, clusters, farestPoint, anchorBP(2,:));
            paths{1} = [partialPath_1; partialPath_2];
        else
            [paths{1}, clusters] = retrievePathFromDijkstra(clusterIndex, clusters, anchorBP(1,:), anchorBP(2,:));
        end
    end
    pairedIndexes(1,:) = [1 2];
else
    % CASO CLUSTER_RANK > 2
    % Accoppiamo le direzioni che hanno una differenza tra loro più vicina
    % a 180° e continuiamo cosi per esclusione. Il path tra loro viene
    % trovato tramite dijkstra.
    numPaths = clusterRank/2;
    paths = cell(1, numPaths);
    
    pairedIndexes = retrieveGoodContinuityIndexesEvenRank(numPaths, clusterIndex, image, clusters, options);
    
    for i = 1 : numPaths
        indexes = pairedIndexes(i,:);
        source = anchorBP(indexes(1),:);
        destination = anchorBP(indexes(2),:);
        [paths{i}, clusters] = retrievePathFromDijkstra(clusterIndex, clusters, source, destination);
    end
end

clusters(clusterIndex).relationship = Single(pairedIndexes, paths);
clusters(clusterIndex).processed = true;



end