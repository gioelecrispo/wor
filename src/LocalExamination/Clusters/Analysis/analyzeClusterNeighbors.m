function possibleDirections = analyzeClusterNeighbors(cpoint, clusterPoints)
    
    numNeighbors = 8;
    directions = zeros(numNeighbors, 2);
    directions(1,:) = Directions.UP;
    directions(2,:) = Directions.UP_LEFT;
    directions(3,:) = Directions.UP_RIGHT;
    directions(4,:) = Directions.RIGHT;
    directions(5,:) = Directions.LEFT;
    directions(6,:) = Directions.DOWN;
    directions(7,:) = Directions.DOWN_LEFT;
    directions(8,:) = Directions.DOWN_RIGHT;
    
    px = zeros(numNeighbors, 2);
    for i = 1 : numNeighbors
        px(i,:) = cpoint + directions(i,:); 
    end

    possibleDirections = zeros(numNeighbors, 2);
    for i = 1 : numNeighbors
        ind = find(clusterPoints(:,1) == px(i,1) & clusterPoints(:,2) == px(i,2), 1);
        if ~isempty(ind)
           possibleDirections(i) = directions(i,:);
        end
    end

    % REMOVE NO-DIRECTION
    indexes = possibleDirections(:,1) == 0 & possibleDirections(:,2) == 0;
    possibleDirections(indexes,:) = [];
    
end