function [image, clusters] = process1RankCluster(clusterIndex, image, clusters, options)

logger = getLogger(options);
logger.info('Processing 1-Rank cluster : %d', clusterIndex);

%%% Getting cluster information
pixels = clusters(clusterIndex).pixels;
falseTracePoints = clusters(clusterIndex).falseTracePoints;
clusterPoints = [pixels; falseTracePoints];
anchorBP = clusters(clusterIndex).anchorBP;
exitDirections = clusters(clusterIndex).exitDirections;

%%% Finding the farthest cluster point 
% We chose the farthest point of the cluster as final point. The final
% point from the anchor branch point is used to define a roundtrip path.
distancesFromAnchorBP = computeDistancesFromPoint(anchorBP, clusterPoints);
[~, maxIndex] = max(distancesFromAnchorBP);
farthestPoint = clusterPoints(maxIndex,:);

%%% Computing the roundtrip paath
[partialPath1, clusters] = retrievePathFromDijkstra(clusterIndex, clusters, anchorBP(1,:), farthestPoint);
[partialPath2, clusters] = retrievePathFromDijkstra(clusterIndex, clusters, farthestPoint, anchorBP(1,:));
paths{1} = [partialPath1; partialPath2(2:end,:)];
pairedIndexes(1,:) = [1 1];
clusters(clusterIndex).relationship = Unique(pairedIndexes, paths);
clusters(clusterIndex).processed = true;

%%% Defining the anchor branch point as an END-POINT-CLUSTER point
image = setClusterEndPoint(image, anchorBP, clusterIndex);

end

