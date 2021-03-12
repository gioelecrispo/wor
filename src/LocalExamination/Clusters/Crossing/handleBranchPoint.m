function [currPixel, direction, path] = handleBranchPoint(image, clusters, options, currPixel, oppositeDirection)

logger = getLogger(options);

%%% Getting the beloging cluster
%[~, clusterIndex] = checkClusterMembership(currPixel, oppositeDirection, clusters);
clusterIndex = getBelongingCluster(image, currPixel);
logger.debug('Crossing cluster: %d', clusterIndex);
if isnan(clusterIndex)
    logger.error('HANDLE_BRANCH_POINT_ERROR: [%d %d] is not a Cluster point or some problems there was in assigning the clusterIndex.', currPixel(1), currPixel(2));
    error('HANDLE_BRANCH_POINT_ERROR: [%d %d] is not a Cluster point or some problems there was in assigning the clusterIndex.', currPixel(1), currPixel(2));
end

%%% Getting the anchor branch point index 
anchorBP = clusters(clusterIndex).anchorBP;
exitDirections =  clusters(clusterIndex).exitDirections;
[ABPfound, ABPIndex] = belongsToCluster(currPixel, oppositeDirection, anchorBP, exitDirections);

%%% Getting the crossing path
path = [];
if ABPfound == true
    if ~isempty(clusters(clusterIndex).relationship)
        [nextIndex, path] = clusters(clusterIndex).relationship.crossCluster(ABPIndex, clusters);
    end
end

if ~isempty(path)
    % Adjusting the path if source and destination are inverted
    if isTheSamePoint(path(end,:), currPixel)
        path = path(end:-1:1,:);
    end
else
    direction = Directions.NO_DIRECTION;
    logger.warn('TRACE_WARN: trace following is not handled for the cluster %d', clusterIndex);
    return;
end


%%% Crossing cluster
[currPixel, ~] = crossCluster(currPixel, path);


%%% Getting exit direction
if isnan(nextIndex)
    direction = Directions.NO_DIRECTION;
else    
    direction = exitDirections(nextIndex,:);
end


end
