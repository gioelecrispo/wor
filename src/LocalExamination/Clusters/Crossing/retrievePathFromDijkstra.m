function [path, clusters] = retrievePathFromDijkstra(clusterIndex, clusters, source, destination)

pixels = clusters(clusterIndex).pixels;
falseTracePoints = clusters(clusterIndex).falseTracePoints;
clusterPoints = [pixels; falseTracePoints];
[newWeight, ~] = size(clusterPoints);
graph = clusters(clusterIndex).graph;

%%% Computing Dijkstra
[~, rute] = dijkstra(graph);

%%% Getting the indexes of the path
clusterStartIndex = findPositionInsideCluster(source, clusterPoints);
clusterEndIndex = findPositionInsideCluster(destination, clusterPoints);

%%% GEtting the path rute
if iscell(rute)
    pathRute = rute{clusterStartIndex, clusterEndIndex};
else
    pathRute = rute(clusterStartIndex, clusterEndIndex);
end

%%% Getting the pixels of the path
lengthPathRute = length(pathRute);
path = zeros(lengthPathRute, 2);
for i = 1 : lengthPathRute
    path(i,:) = clusterPoints(pathRute(i),:);
end

%%% Updating the weights of the graph
% We operate a change of the pixels we cross in order to not use them
% again when computing a new path.
clusters = changeGraphWeight(pathRute, newWeight, clusterIndex, clusters);

end