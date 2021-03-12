function clusters = resetClustersData(clusters)

lengthClusters = length(clusters);
for clusterIndex = 1 : lengthClusters
    relationship = clusters(clusterIndex).relationship;
    if isa(relationship, 'Unique')
       clusters(clusterIndex).relationship.starter = false;
    elseif isa(relationship, 'Married')
        
    elseif isa(relationship, 'Solo')
        clusters(clusterIndex).relationship.arrivedFrom = [];
    end
end

end