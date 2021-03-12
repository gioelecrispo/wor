function [image, clusters] = computeClusterExternalAngles(clusterIndex, image, clusters, options, numPixels)

logger = getLogger(options);

%%% Getting cluster information
anchorBP = clusters(clusterIndex).anchorBP;
exitDirections = clusters(clusterIndex).exitDirections;
clusterRank = clusters(clusterIndex).clusterRank;


%%% ANGLE ANALYSIS 
% To understand and analyze the width of the exit angles of the
% cluster you need to see the next numPixels starting from
% branch points. A multiscale approach will then be used to find the
% precise value of the angle under examination.

externalAngles = zeros(1, clusterRank);
for i = 1 : clusterRank
    %fprintf('anchorBP_EXT [%d, %d]\n', anchorBP(i,1), anchorBP(i,2)); %TODO togliere
    exitDirection = exitDirections(i,:);
    starter = anchorBP(i,:) + exitDirection;
    [~, ~, previousDirections] = traceFollowing_local(image, clusters, options, starter, exitDirection, numPixels);
    externalAngles(i) = previousDirections.computeAngleMultiscale();
end


%%% Updating cluster information
clusters(clusterIndex).externalAngles = externalAngles;

end