function [unfolder, currPixel, unfoldedPixels] = traceFollowing_fromAToB(image, clusters, options, unfolder, starter, ender)

logger = getLogger(options);


% This fucntion applies the traceFollowing algotrithm from a Point A (starter)
% to a point B (ender).
% starter is the Starting Point (or A);
% ender is the Ending Point (or B);

% Since A or B could be cluster points (for which the trace following
% algorithm is not univocal), it is necessary reconduct them to the
% nearest trace point outside the cluster.
[starter, clusters, unfolder, skipConditionStarter] = adjustOnlinePoint(image, clusters, options, unfolder, starter, true);
[ender, clusters, unfolder, skipConditionEnder] = adjustOnlinePoint(image, clusters, options, unfolder, ender, false);


% The traceFollowing function takes in the skeleton image,
% the toolMatrix, the BP clusters and the start point and execute the
% routing of the handwritten trace component starting from
% start point defined by starter. A component is a piece of track
% isolated, separated from others by a pen-up.
% Returns the array of the routed points of the component in output
% exam and the array of directions followed to untangle it.
% The output is the last routed point of the component under test.
currPixel = starter;
unfoldedPixels = [];
previousDirections = DirectionsQueue(Thresholds.NUM_PIXELS_EXPLORATION);
oppositeDirection = Directions.NO_DIRECTION;

if skipConditionStarter == false
    whileCondition = true; % doWhile logic: do the first step then check the condition
    while whileCondition

        [currPixel, direction, unfoldedPixels] = traceFollowing(image, clusters, options, currPixel, oppositeDirection);

        % Update "global" information, ie:
        % - unfoldedArray,
        %   the vector that takes into account the routing
        % - unfolderCounter,
        %   the routing counter
        % - tracedMatrix,
        %   the support matrix that takes into account how many times it is
        %   passed for a given pixel
        [lengthUnfoldedPixels, ~] = size(unfoldedPixels);
        for up = 1 : lengthUnfoldedPixels
            unfolder.unfoldedArray(unfolder.unfolderCounter, :) = unfoldedPixels(up,:);
            unfolder.unfolderCounter = unfolder.unfolderCounter + 1;
            unfolder.tracedMatrix(unfoldedPixels(up,1), unfoldedPixels(up,2)) = unfolder.tracedMatrix(unfoldedPixels(up,1), unfoldedPixels(up,2)) + 1; 
        end

        %unfolder.unfoldedArray(unfolder.unfolderCounter, :) = currPixel;
        %unfolder.unfolderCounter = unfolder.unfolderCounter + 1;
        %unfolder.tracedMatrix(currPixel(1), currPixel(2)) = unfolder.tracedMatrix(currPixel(1), currPixel(2)) + 1; 
        if checkLoop(unfolder, currPixel)
            break;
        end


        % Update "local" information, ie:
        % - currPixel,
        %   the current pixel to be analyzed
        % - previousDirections
        %   the queue that keeps track of the 5 previous directions
        % - oppositeDirection
        %   the direction from where we came, to avoid going back
        currPixel = currPixel + direction;
        previousDirections.add(direction);
        oppositeDirection = computeOppositeDirection(direction);

        endPointFound = isEndPoint(image, currPixel); 
        clusterEndPointFound = isEndPoint(image, currPixel) && isBranchPoint(image, currPixel); 
        whileCondition = ~endPointFound && ~clusterEndPointFound; 
    end


    % Last point -> END_POINT final
    unfolder.unfoldedArray(unfolder.unfolderCounter, :) = currPixel;
    unfolder.unfolderCounter = unfolder.unfolderCounter + 1;
    unfolder.tracedMatrix(currPixel(1), currPixel(2)) = unfolder.tracedMatrix(currPixel(1), currPixel(2)) + 1; 
end




end