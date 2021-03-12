function possibileDirections = analyzeNeighbors(currPixel, image)

rows = image.dimensions(1);
cols = image.dimensions(2);
x = currPixel(1);
y = currPixel(2);
possibileDirections = []; 
% neighboors
if x ~= 1  % prima riga -> no up
    neighbor_up = image.bw(x-1,y);
    if neighbor_up == PointType.BLACK
        possibileDirections = [possibileDirections; [-1 0]];
    end
end
if x ~= rows % ultima riga -> no down
    neighbor_down = image.bw(x+1,y);
    if neighbor_down == PointType.BLACK
        possibileDirections = [possibileDirections; [+1 0]];
    end
end
if y ~= 1 % prima colonna -> no left
    neighbor_left = image.bw(x,y-1);
    if neighbor_left == PointType.BLACK
        possibileDirections = [possibileDirections; [0 -1]];
    end
end
if y ~= cols % ultima colonna -> no right
    neighbor_right = image.bw(x,y+1);
    if neighbor_right == PointType.BLACK
        possibileDirections = [possibileDirections; [0 +1]];
    end
end
if x ~= 1 && y ~= 1 % primo pixel in alto a sx -> no up-left
    neighbor_up_left = image.bw(x-1,y-1);
    if neighbor_up_left == PointType.BLACK
        possibileDirections = [possibileDirections; [-1 -1]];
    end
end
if x ~= 1 && y ~= cols % ultimo pixel della 1 riga -> no up-right
    neighbor_up_right = image.bw(x-1,y+1);
    if neighbor_up_right == PointType.BLACK
        possibileDirections = [possibileDirections; [-1 +1]];
    end
end
if x ~= rows && y ~= 1 % ultimo pixel della 1 colonna -> no down-left
    neighbor_down_left = image.bw(x+1,y-1);
    if neighbor_down_left == PointType.BLACK
        possibileDirections = [possibileDirections; [+1 -1]];
    end
end
if x ~= rows && y ~= cols % ultimo pixel in basso a dx -> no down-right
    neighbor_down_right = image.bw(x+1,y+1);
    if neighbor_down_right == PointType.BLACK
        possibileDirections = [possibileDirections; [+1 +1]];
    end
end

