function drawSegmentCurvature(points, numPoints, aroundness)

%%% COMPUTA CURVATURA
[~, curvature, selectedPoints] = evaluateCurvatureMultiscale(points, numPoints, aroundness);


%%% DIMENSIONI IMMAGINE
offset = 5;
minX = min(points(:,1));
maxX = max(points(:,1));
minY = min(points(:,2));
maxY = max(points(:,2));



%%%%% DISEGNO
%%% COLORS
COLOR_PIXELS              = [0.5 0.5 0.5];         % GRAY
COLOR_SELECTED_POINTS     = [0.7 0 0];             % DARK RED
COLOR_BACKGROUND          = [1 1 1];               % WHITE
COLOR_TEXT                = [0 0 0];               % WHITE

%%% DISEGNO L'IMMAGINE 
rows = maxX+offset;
cols = maxY+offset;
img = ones(rows, cols, 3); 
for i = 1 : rows
   for j = 1 : cols
       img(i, j, :) = COLOR_BACKGROUND;
   end
end

%%% DISEGNO I PX SULL'IMMAGINE
[lengthPoints, ~] = size(points);
for i = 1 : lengthPoints
    img(points(i,1), points(i,2), :) = COLOR_PIXELS;
end

%%% DISEGNO I SELECTED POINTS SULL'IMMAGINE
[lengthSelectedPoints, ~] = size(selectedPoints);
for i = 1 : lengthSelectedPoints
    img(selectedPoints(i,1), selectedPoints(i,2), :) = COLOR_SELECTED_POINTS;
end


% inizializzo figura
figure('units', 'normalized', 'outerposition', [0 0 1 1]), 
% disegno l'immagine
imagesc(img), colormap(gray), hold on, axis equal
% disegno gli angoli
for i = 1 : numPoints
    [~, index] = belongsTo(selectedPoints(i,:), points, false);
    if index > aroundness
        %line([points(index,2) points(index-aroundness,2)], [points(index,1) points(index-aroundness,1)], 'Color', COLOR_SELECTED_POINTS);
    end
    if index < lengthPoints - aroundness
        %line([points(index,2) points(index+aroundness,2)], [points(index,1) points(index+aroundness,1)], 'Color', COLOR_SELECTED_POINTS);
    end
    %text(points(index,2)+1, points(index,1)+1, num2str(curvature(i)), 'FontSize', 10, 'FontWeight', 'bold', 'Color', COLOR_TEXT);
end

% imposto gli assi
axis([minY-offset maxY+offset, minX-offset maxX+offset]);

end