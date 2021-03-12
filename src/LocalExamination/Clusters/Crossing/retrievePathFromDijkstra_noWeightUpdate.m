function path = retrievePathFromDijkstra_noWeightUpdate(rute, clusterPoints, source, destination)



%%% OTTENGO GLI INDICI DEL PERCORSO
clusterStartIndex = findPositionInsideCluster(source, clusterPoints);
clusterEndIndex = findPositionInsideCluster(destination, clusterPoints);

if iscell(rute)
    pathRute = rute{clusterStartIndex, clusterEndIndex};
else
    pathRute = rute(clusterStartIndex, clusterEndIndex);
end

%%% OTTENGO I PIXELS DEL PERCORSO
lengthPathRute = length(pathRute);
path = zeros(lengthPathRute, 2);
for i = 1 : lengthPathRute
    path(i,:) = clusterPoints(pathRute(i),:);
end


end