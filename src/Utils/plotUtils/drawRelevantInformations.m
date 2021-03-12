function [] = drawRelevantInformations(image, clusters)

pointsMatrix = image.pointsMatrix;

%%%%% DISEGNO
%%% COLORS
COLOR_BRANCH_POINT          = [0 0 0];               % BLACK
COLOR_ANCHOR_BRANCH_POINT   = [0.35 0.2 0.6];        % VIOLET
COLOR_TRACE_POINT           = [0.5 0.5 0.5];         % GRAY
COLOR_BACKGROUND            = [1 1 1];               % WHITE
COLOR_END_POINT             = [0.8 0.0 0.0];         % DARK_RED
COLOR_RETRACING_POINT       = [0.2 0.2 0.8];         % BLUE
COLOR_FALSE_TRACE_POINT     = [0.9 0.5 0];           % ORANGE
COLOR_CLUSTER               = [0.3 0.6 0.3];         % GREEN
COLOR_CLUSTER_DELETED       = [0.7 0.7 0.7];         % LIGHT GRAY


%%% DISEGNO L'IMMAGINE
dimensions = image.dimensions;
rows = dimensions(1);
cols = dimensions(2);
img = ones(rows, cols, 3);
for i = 1 : rows
    for j = 1 : cols
        img(i, j, :) = COLOR_BACKGROUND;
    end
end


tracePoints = getTracePoints(image);
[lengthTracePoints, ~] = size(tracePoints);
for p = 1 : lengthTracePoints
    pixel = tracePoints(p,:);
    img(pixel(1),pixel(2),:) = COLOR_TRACE_POINT;
end
falseTracePoints = getFalseTracePoints(image);
[lengthFalseTracePoints, ~] = size(falseTracePoints);
for p = 1 : lengthFalseTracePoints
    pixel = falseTracePoints(p,:);
    img(pixel(1),pixel(2),:) = COLOR_FALSE_TRACE_POINT;
end
branchPoints = getBranchPoints(image);
[lengthBranchPoints, ~] = size(branchPoints);
for p = 1 : lengthBranchPoints
    pixel = branchPoints(p,:);
    img(pixel(1),pixel(2),:) = COLOR_BRANCH_POINT;
end
anchorBranchPoints = getAnchorBranchPoints(image);
[lengthAnchorBranchPoints, ~] = size(anchorBranchPoints);
for p = 1 : lengthAnchorBranchPoints
    pixel = anchorBranchPoints(p,:);
    img(pixel(1),pixel(2),:) = COLOR_ANCHOR_BRANCH_POINT;
end
endPoints = getEndPoints(image);
[lengthEndPoints, ~] = size(endPoints);
for p = 1 : lengthEndPoints
    pixel = endPoints(p,:);
    img(pixel(1),pixel(2),:) = COLOR_END_POINT;
end
retracingPoints = getRetracingPoints(image);
[lengthRetracingPoints, ~] = size(retracingPoints);
for p = 1 : lengthRetracingPoints
    pixel = retracingPoints(p,:);
    img(pixel(1),pixel(2),:) = COLOR_RETRACING_POINT;
end





%%% Plot initialization
% Defining Figure
figure('units', 'normalized', 'outerposition', [0 0 1 1]),
% Writing image
imagesc(img), colormap(gray), hold on,

%%% Drawing markers
for i = 1 : lengthFalseTracePoints
    plot(falseTracePoints(i,2), falseTracePoints(i,1), 'ro', 'MarkerSize', 8, 'MarkerEdgeColor', COLOR_FALSE_TRACE_POINT, 'MarkerFaceColor', COLOR_FALSE_TRACE_POINT);
end
for i = 1 : lengthEndPoints
    plot(endPoints(i,2), endPoints(i,1), 'ro', 'MarkerSize', 8, 'MarkerEdgeColor', COLOR_END_POINT, 'MarkerFaceColor', COLOR_END_POINT);
end
for i = 1 : lengthRetracingPoints
    plot(retracingPoints(i,2), retracingPoints(i,1), 'ro', 'MarkerSize', 8, 'MarkerEdgeColor', COLOR_RETRACING_POINT, 'MarkerFaceColor', COLOR_RETRACING_POINT);
end

%%% Drawing cluster rects
[~, lengthClusters] = size(clusters);
for clusterIndex = 1 : lengthClusters
    pixels = clusters(clusterIndex).pixels;
    falseTracePoints = clusters(clusterIndex).falseTracePoints;
    clusterPoints = [pixels; falseTracePoints];
    
    % Getting cluster circumscribed rect
    minX = min(clusterPoints(:,1));
    maxX = max(clusterPoints(:,1));
    minY = min(clusterPoints(:,2));
    maxY = max(clusterPoints(:,2));
    rect(clusterIndex,:) = [minY-0.5, minX-0.5, (maxY-minY)+1, (maxX-minX)+1];
    if ~clusters(clusterIndex).delete
        rectangle('Position', rect(clusterIndex,:), 'Curvature',[0,0], 'LineWidth', 1, 'LineStyle', '-', 'EdgeColor', COLOR_CLUSTER);
    else
        rectangle('Position', rect(clusterIndex,:), 'Curvature',[0,0], 'LineWidth', 1, 'LineStyle', '-', 'EdgeColor', COLOR_CLUSTER_DELETED);
    end
end


%%% INFORMATIONS
dimDesc = [0.01 1 1 0];
strDesc = {'END POINT'; 'TRACE POINT'; 'BRANCH POINT'; 'ANCHOR BRANCH POINT'; 'RETRACING POINT'; 'FALSE TRACE POINT'};
annotation('textbox', dimDesc, 'String', strDesc, 'FitBoxToText', 'on', 'LineStyle', 'none', 'FontWeight', 'bold');

DOWN_OFFSET = 0.022;
dimEP = [0.002 1 1 0];
dimTP = [0.002 1-DOWN_OFFSET*1 1 0];
dimBP = [0.002 1-DOWN_OFFSET*2 1 0];
dimABP = [0.002 1-DOWN_OFFSET*3 1 0];
dimRP = [0.002 1-DOWN_OFFSET*4 1 0];
dimFTP = [0.002 1-DOWN_OFFSET*5 1 0];
strPoint = {'•'};
annotation('textbox', dimEP,  'String', strPoint, 'FitBoxToText', 'on', 'LineStyle', 'none', 'FontWeight', 'bold', 'Color', COLOR_END_POINT);
annotation('textbox', dimTP,  'String', strPoint, 'FitBoxToText', 'on', 'LineStyle', 'none', 'FontWeight', 'bold', 'Color', COLOR_TRACE_POINT);
annotation('textbox', dimBP,  'String', strPoint, 'FitBoxToText', 'on', 'LineStyle', 'none', 'FontWeight', 'bold', 'Color', COLOR_BRANCH_POINT);
annotation('textbox', dimABP, 'String', strPoint, 'FitBoxToText', 'on', 'LineStyle', 'none', 'FontWeight', 'bold', 'Color', COLOR_ANCHOR_BRANCH_POINT);
annotation('textbox', dimRP,  'String', strPoint, 'FitBoxToText', 'on', 'LineStyle', 'none', 'FontWeight', 'bold', 'Color', COLOR_RETRACING_POINT);
annotation('textbox', dimFTP, 'String', strPoint, 'FitBoxToText', 'on', 'LineStyle', 'none', 'FontWeight', 'bold', 'Color', COLOR_FALSE_TRACE_POINT);


end