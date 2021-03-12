 function [image, clusters] = computeClusterInfo(clusterIndex, image, clusters, options)


%%% COMPUTING ANCHOR BRANCH POINT, EXIT DIRECTIONS, FALSE TRACE POINTS, CLUSTER RANK
[image, clusters] = computeAnchorBPAndExitDirections(clusterIndex, image, clusters, options);

%%% COMPUTING EXTERNAL ANGLES, INTERNAL ANGLES
[image, clusters] = computeClusterInternalAngles(clusterIndex, image, clusters, options, Thresholds.NUM_PIXELS_EXPLORATION);
[image, clusters] = computeClusterExternalAngles(clusterIndex, image, clusters, options, Thresholds.NUM_PIXELS_EXPLORATION);

%%% COMPUTING BRANCHES CURVATURE
%branchesCurvature = computeClusterBranchesCurvature(clusterIndex, image, clusters, Thresholds.NUM_PIXELS_EXPLORATION);
%clusters(clusterIndex).branchesCurvature = branchesCurvature;

%%% COMPUTING ADJACENCY MATRIX
[image, clusters] = computeGraph(clusterIndex, image, clusters, options);

%%% COMPUTING CONTRIBUTIONS
[image, clusters] = computeExitBranchesContributions(clusterIndex, image, clusters, options);


%%% INITIALIZING RELATIONSHIP AND HANDLING FLAGS
clusters(clusterIndex).relationship = [];
clusters(clusterIndex).processed = false;
clusters(clusterIndex).delete = false;

end