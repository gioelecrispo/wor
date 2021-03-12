function commonPoints = findNeighborPoints(px1, px2)
    neighborDirections = zeros(8, 2);
    px = zeros(8, 2);
    distances = zeros(8, 2);
    
    px(1,:) = px1 + Directions.UP;
    px(2,:) = px1 + Directions.UP_LEFT;
    px(3,:) = px1 + Directions.UP_RIGHT;
    px(4,:) = px1 + Directions.RIGHT;
    px(5,:) = px1 + Directions.LEFT;
    px(6,:) = px1 + Directions.DOWN;
    px(7,:) = px1 + Directions.DOWN_LEFT;
    px(8,:) = px1 + Directions.DOWN_RIGHT;
    
    for i = 1 : 8
        distances(i,:) = px(i,:) - px2;
    end
    
    for i = 1 : 8
       if abs(distances(i,1)) <= 1 && abs(distances(i,2)) <= 1
           neighborDirections(i,:) = computeOppositeDirection(distances(i,:));
       end
    end
    deletion = neighborDirections(:,1)==0 & neighborDirections(:,2)==0;
    neighborDirections(deletion,:) = [];
    
    [lengthNeighborDirection, ~] = size(neighborDirections);
    commonPoints = zeros(lengthNeighborDirection, 2);
    for i = 1 : lengthNeighborDirection
         commonPoints(i,:) = px1 + neighborDirections(i,:);
    end

end