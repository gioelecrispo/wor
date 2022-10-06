function anglediff = angdiffd(angle1, angle2)
% This function calculates the difference in degrees between two angles. 
% It is the consideration of angdiff that performs the calculation in radians.
% The function takes as input two vectors, which must have the same length, 
% and calculates the difference by comparing the i-th element of the first 
% vector with the i-th element of the second.

if nargin == 1 
    anglediff = angdiffd(angle1(2:end), angle1(1:end-1))
elseif nargin == 2
    if length(angle1) == length(angle2)
        anglediff = zeros(1, length(angle1));
        for i = 1 : length(angle1)
            anglediff1 = mod(angle2(i) - angle1(i), 360); 
            anglediff2 = mod(angle1(i) - angle2(i), 360);

            if anglediff1 < anglediff2 
                anglediff(i) = anglediff1;
            else
                anglediff(i) = anglediff2;
            end
        end
    else
        error('Angle1, Angle2 have different lengths'); 
    end
else
    error('Input size not expected');
end
end
