function [bool, i] = belongsToCluster(point, oppositeDirection, anchorBP, exitDirections)
% This function search in the set of cluster anchorBP and exitDirections to
% find the index of an Anchor branch point.
% An anchor branch point is fully identified throug two parameters:
%  - the x, y coordinates in the image;
%  - the corresponding exit direction
%
% In fact, in a cluster, there could be two or more anchor branch point
% with the same x, y coordinates, but with a different exit direction.

[bool, i] = belongsTo(point, anchorBP, false);
if length(i) >= 2
    bool = false; 
end

[anchorBPLength, ~] = size(anchorBP);
if bool == false
    for i = 1 : anchorBPLength
        if isTheSamePoint(point, anchorBP(i,:)) && isTheSameDirection(oppositeDirection, exitDirections(i,:))
            bool = true;
            break;
        end
    end
end



end