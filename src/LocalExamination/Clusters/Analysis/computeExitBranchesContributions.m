function [image, clusters] = computeExitBranchesContributions(clusterIndex, image, clusters, options)
% The function calculates the possible combinations of angles that must be
% compared in order to make the difference; based on these calculations
% difference on internal angles and external angles. Then also the
% curvature of each pair of exit branches is considered.

logger = getLogger(options);

%%% GETTING CLUSTER INFORMATION
pixels = clusters(clusterIndex).pixels;
falseTracePoints = clusters(clusterIndex).falseTracePoints;
clusterPoints = [pixels; falseTracePoints];
anchorBP = clusters(clusterIndex).anchorBP;
exitDirections = clusters(clusterIndex).exitDirections;
clusterRank = clusters(clusterIndex).clusterRank;
externalAngles = clusters(clusterIndex).externalAngles;
internalAnglesFrom0 = clusters(clusterIndex).internalAnglesFrom0;
G = clusters(clusterIndex).graph;
[~, rute] = dijkstra(G);



if clusterRank == 0 || clusterRank == 1
    combinations = [];
    externalAnglesDistances = [];
    internalAnglesDistances = [];
    dijkstraCurvatures = [];
    return;
end
    
%%% COMPUTING EXIT BRANCHES
exitBranches = cell(1, clusterRank);
for i = 1 : clusterRank
    exitDirection = exitDirections(i,:);
    starter = anchorBP(i,:) + exitDirections(i,:); 
    [~, unfoldedArray, ~] = traceFollowing_local(image, clusters, options, starter, exitDirection, Thresholds.NUM_PIXELS_EXPLORATION);
    
    exitBranches{i} = unfoldedArray;
end


%%% COMPUTING DISTANCES
% They are calculated for every combination of anchor pairs BP the
% following quantities:
% 1. External Angles Distances
% 2. Internal Angles Distances
% 3. Dijkstra Curvature
%
%      CLUSTER         COMBINATIONS     EXT_ANGLES   INT_ANGLES   DIJKSTRA
%                         1    2            e12          i12         c12 
%  1  _ _____ _ 3         1    3            e13          i13         c13
%      |     |            1    4            e14          i14         c14
%  2  _|_____|_ 4         2    3            e23          i23         c23
%                         2    4            e24          i24         c24
%                         3    4            e34          i34         c34
%%%%%
combinations = nchoosek(1:clusterRank, 2);
[lengthCombinations, ~] = size(combinations);
externalAnglesDistances = zeros(1, lengthCombinations);
internalAnglesDistances = zeros(1, lengthCombinations);
dijkstraCurvatures = zeros(1, lengthCombinations);
for k = 1 : lengthCombinations
    i = combinations(k,1);
    j = combinations(k,2);
    
    % EXTERNAL ANGLES
    externalAnglesDistances(k) = angdiffd(externalAngles(i), externalAngles(j));
    
    % EXTERNAL ANGLES
    internalAnglesDistances(k) = angdiffd(internalAnglesFrom0(i), internalAnglesFrom0(j));
    
    % DIKSTRA CURVATURE
    source = anchorBP(i,:);
    destination = anchorBP(j,:);
    dijkstraPath = retrievePathFromDijkstra_noWeightUpdate(rute, clusterPoints, source, destination);
    segment = [exitBranches{i}(end:-1:1,:); dijkstraPath;  exitBranches{j}];
    [lengthSegment, ~] = size(segment);
    [representativeCurvature, anglesDirection, ~] = evaluateCurvatureMultiscale(segment, lengthSegment, Thresholds.CURVATURE_AROUNDNESS);
    dijkstraCurvatures(k) = representativeCurvature;
end



%%% Updating cluster information
clusters(clusterIndex).branchesCombinations = combinations;
clusters(clusterIndex).externalAnglesDistances = externalAnglesDistances;
clusters(clusterIndex).internalAnglesDistances = internalAnglesDistances;
clusters(clusterIndex).dijkstraCurvatures = dijkstraCurvatures;

end