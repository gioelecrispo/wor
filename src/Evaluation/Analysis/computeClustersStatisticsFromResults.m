function statistics = computeClustersStatisticsFromResults(results)

[~, lengthResults] = size(results);


allClusterRanks = [];
allResolved = [];
for i = 1 : lengthResults
    stats = results(i).statistics;
    allClusterRanks = [allClusterRanks; cell2mat(retrieveStructureField(stats, 'clusterRank'))];
    allResolved = [allResolved; cell2mat(retrieveStructureField(stats, 'resolved'))];
end

statistics.clusterRank = allClusterRanks;
statistics.resolved = allResolved;


end