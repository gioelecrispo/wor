function [dbIndex, clusterIndex] = findNotResolvedClusterInDB(results, cIndex)


[~, lengthResults] = size(results);

% INIZIALIZZO OUTPUT
dbIndex = [];
clusterIndex = [];

% CERCO NEL DB
numClusters = 0;
for i = 1 : lengthResults
    numClusters = numClusters + length(results(i).statistics);
    if numClusters >= cIndex
        dbIndex = i;
        clusterIndex = cIndex - (numClusters - length(results(i).statistics));
        return; 
    end
end




