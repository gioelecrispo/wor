function clusterPointsWithoutAnchorBP = deleteAnchorBPFromCluster(clusterPoints, anchorBP)

[lengthAnchorBP, ~] = size(anchorBP);
[lengthClusterPoints, ~] = size(clusterPoints);

% NON CANCELLO MAI IL PRIMO
% Così che se nel cluster dovessero esserci solo anchorBP, dopo la
% procedura ho almeno un punto del cluster da considerare.

deleteIndexes = true(1, lengthClusterPoints);
for i = 2 : lengthAnchorBP
    point = anchorBP(i,:); 
    [~, position] = belongsTo(point, clusterPoints, true);
    deleteIndexes(position) = false;
end

clusterPointsWithoutAnchorBP = clusterPoints(deleteIndexes,:);


end