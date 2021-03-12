function bool = isTheSameDirection(direction1, direction2)
    if sum(direction1 == direction2) == 2
        bool = true;
    else
        bool = false;
    end
end