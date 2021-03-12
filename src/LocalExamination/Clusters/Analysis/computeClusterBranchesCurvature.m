function branchesCurvature = computeClusterBranchesCurvature(clusterIndex, image, clusters, numPixels)

anchorBP = clusters(clusterIndex).anchorBP;
exitDirections = clusters(clusterIndex).exitDirections;
clusterRank = clusters(clusterIndex).clusterRank;

branchesCurvature = zeros(1, clusterRank);
for i = 1 : clusterRank
    exitDirection = exitDirections(i,:);
    starter = anchorBP(i,:) + exitDirections(i,:); 
    [~, unfoldedArray, ~] = traceFollowing_local(image, clusters, starter, exitDirection, numPixels);
    
    branchesCurvature(i) = normalizeCurvature(evaluateCurvatureMultiscale(unfoldedArray, numPixels, Thresholds.CURVATURE_AROUNDNESS));
end




end