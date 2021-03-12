function bool = isTheSamePoint(pt1, pt2)
    if sum(pt1 == pt2) == 2
        bool = true;
    else
        bool = false;
    end
end