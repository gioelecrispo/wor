function clusters = changeGraphWeight(pathRute, newWeight, clusterIndex, clusters)

graph = clusters(clusterIndex).graph;

graph(pathRute,:) = graph(pathRute,:) * newWeight;
graph(:,pathRute) =  graph(:,pathRute) * newWeight;

clusters(clusterIndex).graph = graph;

end