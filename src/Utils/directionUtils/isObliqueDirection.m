function bool = isObliqueDirection(direction)

if direction(1) ~= 0 && direction(2) ~= 0
    bool = true;
else
    bool = false;
end

end