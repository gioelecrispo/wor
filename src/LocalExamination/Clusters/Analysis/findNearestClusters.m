function [nearClusterPoints, indexesCluster, pxDistances, associatedBPIndexes, clusters] = findNearestClusters(clusterIndex, image, clusters, options)

%%% OTTENIMENTO INFO CLUSTER 
anchorBP = clusters(clusterIndex).anchorBP;
exitDirections = clusters(clusterIndex).exitDirections;
clusterRank = clusters(clusterIndex).clusterRank;

%%% INIZIALIZZAZIONE OUTPUT
pxDistances = zeros(clusterRank, 1);
indexesCluster = zeros(clusterRank, 1);
nearClusterPoints = zeros(clusterRank, 2);
associatedBPIndexes = zeros(clusterRank, 2);

%%% ESPLORAZIONE RAMI D'USCITA
% Su ogni ramo cerco un cluster, attraversando i cluster quando possibile 
% (cioè se sono stati risolti già).
for i = 1 : clusterRank
    exitDirection = exitDirections(i,:);
    starter = anchorBP(i,:) + exitDirection;
    [clusterFound, clusterIndexFound, pxCounter, cPoint, anchorBPIndex] = traceFollowing_untilNextCluster(image, clusters, options, starter, exitDirection);
    if clusterFound == true 
        associatedBPIndexes(i,:) = [i anchorBPIndex];
        indexesCluster(i) = clusterIndexFound;
        pxDistances(i) = pxCounter;
        nearClusterPoints(i,:) = cPoint;
    else
        associatedBPIndexes(i,:) = [NaN NaN];
        indexesCluster(i) = NaN;
        pxDistances(i) = NaN;
        nearClusterPoints(i,:) = [NaN NaN];
    end
end


end