function [] = drawOnlineStartingEndingPoints(image, unfolder, options)

startingPoints = unfolder.componentsEdgePoints.startingPoints;
endingPoints = unfolder.componentsEdgePoints.endingPoints;

[lengthPoints, ~] = size(startingPoints);

if options.plot && options.debug
    offsetY = 6;
    offsetX = -3;
    seeimage(image), hold on, axis equal

    %%% PLOT ENDPOINTS
    for i = 1 : lengthPoints 
        currentColor = getColor(i);
        xs = startingPoints(i,1);
        ys = startingPoints(i,2);
        xe = endingPoints(i,1);
        ye = endingPoints(i,2);
        plot(ys, xs, 'ro', 'MarkerSize', 8, 'MarkerEdgeColor', currentColor, 'MarkerFaceColor', currentColor);
        plot(ye, xe, 'ro', 'MarkerSize', 8, 'MarkerEdgeColor', currentColor, 'MarkerFaceColor', currentColor);
        text(ys+offsetY, xs+offsetX, [num2str(i)], 'Color', 'k', 'FontSize', 12);
        text(ye+offsetY, xe+offsetX, [num2str(i)], 'Color', 'k', 'FontSize', 12);
    end
end

end