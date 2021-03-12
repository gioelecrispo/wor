function [starter, startingIndex] = findStartingPoint_global(image, options, endPoints)

% Cerco nel quadrante in alto a sx, poi in basso a sx, poi in alto a dx,
% infinte in basso a dx
[rows, cols] = size(image.bw);
QUADRANTE_UP_LEFT    = [1 1; round(cols/2) round(rows/2)];
QUADRANTE_DOWN_LEFT  = [1 round(rows/2); round(cols/2) rows];
QUADRANTE_UP_RIGHT   = [round(cols/2) 1; cols round(rows/2)];
QUADRANTE_DOWN_RIGHT = [round(cols/2) round(rows/2);  cols, rows];

starter = [];
[lengthEndPoints, ~] = size(endPoints); 
for startingIndex = 1 : lengthEndPoints
   ep = endPoints(startingIndex,:);
   if (ep(1) > QUADRANTE_UP_LEFT(1,1) && ep(1) < QUADRANTE_UP_LEFT(2,1)) && (ep(2) > QUADRANTE_UP_LEFT(1,2) && ep(2) < QUADRANTE_UP_LEFT(2,2))
        starter = ep;
        break;
   end
end
if isempty(starter)
    for startingIndex = 1 : lengthEndPoints
        ep = endPoints(startingIndex,:);
        if (ep(1) > QUADRANTE_DOWN_LEFT(1,1) && ep(1) < QUADRANTE_DOWN_LEFT(2,1)) && (ep(2) > QUADRANTE_DOWN_LEFT(1,2) && ep(2) < QUADRANTE_DOWN_LEFT(2,2))
            starter = ep;
            break;
        end
    end
end
if isempty(starter)
    for startingIndex = 1 : lengthEndPoints
        ep = endPoints(startingIndex,:);
        if (ep(1) > QUADRANTE_UP_RIGHT(1,1) && ep(1) < QUADRANTE_UP_RIGHT(2,1)) && (ep(2) > QUADRANTE_UP_RIGHT(1,2) && ep(2) < QUADRANTE_UP_RIGHT(2,2))
            starter = ep;
            break;
        end
    end
end
if isempty(starter)
    for startingIndex = 1 : lengthEndPoints
        ep = endPoints(startingIndex,:);
        if (ep(1) > QUADRANTE_DOWN_RIGHT(1,1) && ep(1) < QUADRANTE_DOWN_RIGHT(2,1)) && (ep(2) > QUADRANTE_DOWN_RIGHT(1,2) && ep(2) < QUADRANTE_DOWN_RIGHT(2,2))
            starter = ep;
            break;
        end
    end
end


%%% STRATEGIA 2
% Cerca l'endPoint più a sinistra e lo seleziona come primo.
[~, startingIndex] = min(endPoints(:,2));
starter = endPoints(startingIndex,:);




end