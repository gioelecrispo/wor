function angle = obtainAngleFromDirection(direction)
    if isTheSameDirection(direction, [ 0  +1]) 
        angle = 0;
    elseif isTheSameDirection(direction, [-1  +1]) 
        angle = 45;
    elseif isTheSameDirection(direction, [-1   0]) 
        angle = 90;
    elseif isTheSameDirection(direction, [-1  -1]) 
        angle = 135;
    elseif isTheSameDirection(direction, [ 0  -1]) 
        angle = 180;
    elseif isTheSameDirection(direction, [+1  -1]) 
        angle = 225;
    elseif isTheSameDirection(direction, [+1   0]) 
        angle = 270;
    elseif isTheSameDirection(direction, [+1  +1]) 
        angle = 315;
    else
        error('Direction not known');
    end  
end