function bool = checkLoop(unfolder, currPixel)
% This function verifies if a loop is occurred in the untracing process. If
% a pixel is passed more than loopThreshold times, than a loop is occurred
% and based on this condition the algorithm will change the unfonding path.
% Input: unfolding object, representing the unfolding process of a
%     signature
% Output: a boolean, that indicates if a loop is occurred

bool = false;
loopThreshold = 5;
if unfolder.tracedMatrix(currPixel(1), currPixel(2)) > loopThreshold
    bool = true;
end

end