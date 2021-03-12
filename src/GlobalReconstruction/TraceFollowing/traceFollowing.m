function [currPixel, direction, unfoldedPixels] = traceFollowing(image, clusters, options, starter, oppositeDirection)

logger = getLogger(options);

currPixel = starter;
if ~isSkeletonPoint(image, currPixel) %image.toolMatrix(currPixel(1), currPixel(2)) == PointType.NO_SKELETON
    logger.error('TRACE_ERROR: Wrong direction. Point [%d, %d] is outside skeleton.', currPixel(1), currPixel(2));
    error('TRACE_ERROR: Wrong direction. Point [%d, %d] is outside skeleton.', currPixel(1), currPixel(2));
end

% Computing unfolded pixels
unfoldedPixels = currPixel;

possibleDirections = analyzeNeighbors(currPixel, image);
[neighbors, ~] = size(possibleDirections);


if neighbors == PointType.ISOLATED_POINT
    % No possible direction
    direction = Directions.NO_DIRECTION;
elseif neighbors == PointType.END_POINT  
    % only ONE possible direction
    direction = possibleDirections;
elseif neighbors == PointType.TRACE_POINT
    % TWO possible directions, we discard the previous one and move on
    if ~isTheSameDirection(oppositeDirection, Directions.NO_DIRECTION)
        if isTheSameDirection(possibleDirections(1,:), oppositeDirection)
            direction = possibleDirections(2,:);
        else
            direction = possibleDirections(1,:);
        end
    else
        logger.error('TRACE_ERROR: Wrong opposite direction: NO_DIRECTION');
        error('TRACE_ERROR: Wrong opposite direction: NO_DIRECTION');
    end
else
    % branchPoint
    [currPixel, direction, path] = handleBranchPoint(image, clusters, options, currPixel, oppositeDirection);
    % Computing unfolded pixels
    if ~isempty(path)
        unfoldedPixels = path;
    else
        unfoldedPixels = [];
    end
end

end

