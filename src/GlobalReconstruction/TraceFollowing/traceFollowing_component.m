function [unfolder, currPixel, unfoldedPixels] = traceFollowing_component(image, clusters, options, unfolder)

logger = getLogger(options);

starter = unfolder.starters(end,:);

% The traceFollowing function takes in the skeleton image,
% the support matrix, the BP clusters and the start point and execute the
% routing of the handwritten trace component starting from
% start point defined by starter. A component is a piece of track
% isolated, separated from others by a pen-up.
% Returns the array of the routed points of the component in output
% exam and the array of directions followed to untangle it.
% The output is the last routed point of the component under test.
 
if isEndPoint(image, starter) && isBranchPoint(image, starter) %image.toolMatrix(starter(1), starter(2)) == PointType.CLUSTER_END_POINT
    clusterIndex = getBelongingCluster(image, starter); % [~, clusterIndex] = checkClusterMembership_starter(starter, [], clusters);
    clusters(clusterIndex).relationship.starter = true;
end


currPixel = starter;
previousDirections = DirectionsQueue(5);
oppositeDirection = Directions.NO_DIRECTION;


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