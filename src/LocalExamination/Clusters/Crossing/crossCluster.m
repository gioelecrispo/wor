function [currPixel, direction] = crossCluster(currPixel, path)

direction = Directions.NO_DIRECTION;
[lengthPath, ~] = size(path);
for i = 1 : lengthPath - 1 
    point1 = path(i,:);
    point2 = path(i+1,:);
    direction = getDirectionBetweenAdiacentPoint(point1, point2); 
    currPixel = currPixel + direction;
end

end