function [currPixel, unfoldedArray, previousDirections] = traceFollowing_local(image, clusters, options, starter, exitDirection, numPixels)
    
logger = getLogger(options);

% The traceFollowing function takes in the skeleton image,
% the support matrix, the BP clusters and the start point and execute the
% routing of the handwritten trace component starting from
% start point defined by starter
 
currPixel = starter;
previousDirections = DirectionsQueue(numPixels+1);
previousDirections.add(exitDirection);
oppositeDirection = computeOppositeDirection(exitDirection);

unfoldedArray = [];

for pixel = 1 : numPixels
    
    if isEndPoint(image, currPixel) % image.toolMatrix(currPixel(1), currPixel(2)) == PointType.END_POINT
        break;
    end
    
    [currPixel, direction, unfoldedPixels] = traceFollowing(image, clusters, options, currPixel, oppositeDirection);
    
    % Update "local" information, ie:
	% - currPixel,
	%   the current pixel to be analyzed
	% - previousDirections
	%   the queue that keeps track of the 5 previous directions
	% - oppositeDirection
    %   the direction from where we came, to avoid going back
    unfoldedArray = [unfoldedArray; unfoldedPixels];
    currPixel = currPixel + direction;
    previousDirections.add(direction);
    oppositeDirection = computeOppositeDirection(direction); 
end



end
