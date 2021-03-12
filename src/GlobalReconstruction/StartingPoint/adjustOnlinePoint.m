function [point, clusters, unfolder, skipCondition] = adjustOnlinePoint(image, clusters, options, unfolder, point, starting)

logger = getLogger(options);


%%% Checking starter point type
% We need to reconduce the starter point to an end point, so to execute
% correctly the trace following algorithm.
skipCondition = false;
if ~isEndPoint(image, point)
    if isTracePoint(image, point)
        logger.debug('Starting point [%d, %d] is a trace point', point(1), point(2));
    elseif isBranchPoint(image, point) || isFalseTracePoint(image, point)
        clusterIndex = getBelongingCluster(image, point);
        clusterRank = clusters(clusterIndex).clusterRank;
        logger.debug('Online point [%d, %d] is a cluster point', point(1), point(2));
        logger.debug('It belongs to the cluster %d, which has rank: %d', clusterIndex, clusterRank);
    end
    % Searching for the nearest end point (estimated by the algorithm)
    endPoints = getEndPoints(image);
    distancesFromPoint = computeDistancesFromPoint(point, endPoints);
    [~, nearestEPIndex] = min(distancesFromPoint);
    oldPoint = point;
    point = endPoints(nearestEPIndex,:);
    if unfolder.tracedMatrix(point(1), point(2)) >= 1
        if strcmpi(options.version, 'RSENC') == 1
            endCondition = false;
            while ~endCondition
                endPoints(nearestEPIndex,:) = [];
                distancesFromPoint(nearestEPIndex) = [];
                [~, nearestEPIndex] = min(distancesFromPoint);
                point = endPoints(nearestEPIndex,:);
                if isempty(point)
                    skipCondition = true;
                    return;
                end
                endCondition = ~(unfolder.tracedMatrix(point(1), point(2)) >= 1);
            end
            % Setting as traced the old point, in order to not consider it anymore 
            unfolder.tracedMatrix(oldPoint(1), oldPoint(2)) = unfolder.tracedMatrix(oldPoint(1), oldPoint(2)) + 1;
        else
            skipCondition = true;
        end
    else
        % Setting as traced the old point, in order to not consider it anymore 
        unfolder.tracedMatrix(oldPoint(1), oldPoint(2)) = unfolder.tracedMatrix(oldPoint(1), oldPoint(2)) + 1;
    end
    
    
    % starter has been reconducted to an estimated end point, now we have
    % to check if it is a branch point (i.e. it is a cluster end point): in
    % this case we have to mark the cluster as "starter"
    if isAnchorBranchPoint(image, point)
        clusterIndex = getBelongingCluster(image, point);
        clusterRank = clusters(clusterIndex).clusterRank;
        if clusterRank == 1
            if starting == true
                % Setting the 1-rank cluster as a "starter" so we know we have to
                % continue after its crossing.
                clusters(clusterIndex).relationship.starter = true;
            end
            % Take the nearest anchor branch point of the cluster
            anchorBP = clusters(clusterIndex).anchorBP;
            distancesFromPoint = computeDistancesFromPoint(point, anchorBP);
            [~, nearestIndex] = min(distancesFromPoint);
            nearestABP = anchorBP(nearestIndex,:);
            point = nearestABP;
        end
    end
else
   if unfolder.tracedMatrix(point(1), point(2)) >= 1
       skipCondition = true;
   end
end


end