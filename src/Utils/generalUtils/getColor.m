function color = getColor(i)
% This utility function choose a color from the list based on the index i 
% in input. If the index is greater than 10, this function computes a new
% color on the basis of the corresponding mod(i,10) index.
% This is useful, for example, when we are drawing a figure with a lot of 
% components and we need different colors.
% Input: an index
% Output: a color (a triplet of values in the range 0 - 255)


%%% COLORS DEFINITION
colors(1,:) = [255, 128,   0];      % DARK ORANGE
colors(2,:) = [  0, 153, 255];      % LIGHT BLUE (sky)
colors(3,:) = [255,  80,  80];      % FIRE RED
colors(4,:) = [  0, 153,  51];      % DARK GREEN
colors(5,:) = [204,   0, 204];      % PURPLE 
colors(6,:) = [100, 100, 100];      % DARK GREY
colors(7,:) = [  0,   0,   0];      % BLACK
colors(8,:) = [153,  51,   0];      % BROWN
colors(9,:) = [255, 153, 255];      % PINK
colors(10,:) = [51, 204, 204];      % TURQUOISE

numColors = length(colors);

maxValue = 255;
changingPercentage = 0.2;
if i > numColors
    newIndex = mod(i, numColors);
    color = colors(newIndex,:);
    for c = 1 : 3
        if color(c) == 0
            color(c) = color(c) + maxValue*changingPercentage;
        elseif color(c) > 127
            color(c) = color(c) - color(c)*changingPercentage;
        else
            color(c) = color(c) + color(c)*changingPercentage;
        end
    end
else
    color = colors(i,:);
end

% Normalize colors array to match the 0 -> 1 convention
color = color/maxValue;
    