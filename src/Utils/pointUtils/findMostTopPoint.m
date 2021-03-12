function mostTopPoint = findMostTopPoint(points)
% This function find the most right point in a set of 2D-points.
% Input: a set of point
% Output: the most right point of the set



[~, index] = min(points(:,2));
mostTopPoint = points(index, :);
