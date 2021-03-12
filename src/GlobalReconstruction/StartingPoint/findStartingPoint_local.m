function [starter, startingIndex] = findStartingPoint_local(image, options, endPoints, statisticalInitialPoint)

starter = [];

% STATISTICAL INITIAL POINT
% coordinates    = [x0 y0]
%     ottenute come la media del punto iniziale delle firme online 
% radius         = [HORIZ., VERT.] 
%     ottenute come la varianza del punto iniziale delle firme online 
center = statisticalInitialPoint.coordinates;
radius = statisticalInitialPoint.radius;

[rows, cols] = size(image.bw);
centerNorm = round([cols*center(1), rows*(1-center(2))]);
radiusNorm = round([cols*radius(1), rows*radius(2)]);





%endPoints = image.endPoints.points;
[lengthEndPoints, ~] = size(endPoints);

for startingIndex = 1 : lengthEndPoints 
    x = endPoints(startingIndex,1);
    y = endPoints(startingIndex,2);
    % Controllo che il punto sia interno all'ellisse
    if ((x - centerNorm(1))^2)/(radiusNorm(1)^2) + ((y - centerNorm(2))^2)/(radiusNorm(2)^2) < 1
        starter = endPoints(startingIndex,:);
        break;
    end
end


%%% PLOT
if options.plot && options.debug
    COLOR_END_POINT_SELECTED  = [0.2 0.5 0.7];         % TURQUOISE
    COLOR_END_POINT           = [0.8 0.2 0.0];         % RED_ORANGE

    th = 0:pi/50:2*pi;
    xunit = radiusNorm(1) * cos(th) + centerNorm(1);
    yunit = radiusNorm(2) * sin(th) + centerNorm(2);
    seeimage(image), hold on, axis equal

    plot(centerNorm(1), centerNorm(2), 'xk');
    plot(xunit, yunit, 'k');
    h = fill(xunit, yunit, 'r'); set(h, 'facealpha', 0.4)
    %%% PLOT ENDPOINTS
    for i = 1 : lengthEndPoints 
        x = endPoints(i,1);
        y = endPoints(i,2);
        plot(y, x, 'ro', 'MarkerSize', 8, 'MarkerEdgeColor', COLOR_END_POINT, 'MarkerFaceColor', COLOR_END_POINT);
    end
    if ~isempty(starter)
        plot(starter(2), starter(1), 'ro', 'MarkerSize', 8, 'MarkerEdgeColor', COLOR_END_POINT_SELECTED, 'MarkerFaceColor', COLOR_END_POINT_SELECTED);
    end
end



end