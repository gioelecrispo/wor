function [] = drawClusterAnalysis(clusterIndex, clusters)


%%%%% OTTENIMENTO INFORMAZIONI DEL CLUSTER
pixels = clusters(clusterIndex).pixels;
falseTracePoints = clusters(clusterIndex).falseTracePoints;
clusterPoints = [pixels; falseTracePoints];
anchorBP = clusters(clusterIndex).anchorBP;
exitDirections = clusters(clusterIndex).exitDirections;
clusterRank = clusters(clusterIndex).clusterRank;
adiacency = clusters(clusterIndex).adiacency;
internalAngles = clusters(clusterIndex).internalAngles;
internalAnglesFrom0 = clusters(clusterIndex).internalAnglesFrom0;
externalAngles = clusters(clusterIndex).externalAngles;
dijkstraCurvatures = clusters(clusterIndex).dijkstraCurvatures;
clusterCenter = [mean(anchorBP(:,1)), mean(anchorBP(:,2))];



%%%%% CALCOLO INFORMAZIONI
%%% ANGOLI ESTERNI
% Ottengo le exit directions
exitDir = zeros(clusterRank, 2);
length = 4;                  % lunghezza del segmento uscente
for i = 1 : clusterRank
    exitDir(i,1) = anchorBP(i,1) + length * cosd(externalAngles(i)+90);
    exitDir(i,2) = anchorBP(i,2) + length * sind(externalAngles(i)+90);
end


%%% CERCHIO
% Calcolo del raggio, in base alla distanza maggiore dal centro del cluster
% anchorBPdistancesFromCC = zeros(clusterRank, 1);
% for i = 1 : clusterRank
%     anchorBPdistancesFromCC(i) = pdist([clusterCenter; anchorBP(i,:)], 'euclidean');
% end
% [maxDistFromCC, ~] = max(anchorBPdistancesFromCC); 
% radius = maxDistFromCC;
% theta = linspace(0, 2*pi);
% xcirc = radius*cos(theta) + clusterCenter(1);
% ycirc = radius*sin(theta) + clusterCenter(2);


%%% ANGOLI INTERNI
% Ottengo le internal directions
% internalDir = zeros(clusterRank, 2);
% length = radius;                  % lunghezza del segmento uscente
% for i = 1 : clusterRank
%     internalDir(i,1) = clusterCenter(1) + length * cosd(internalAnglesFrom0(i)+90);
%     internalDir(i,2) = clusterCenter(2) + length * sind(internalAnglesFrom0(i)+90);
% end



%%% DIMENSIONI IMMAGINE
offset = 5;
minCX = min(pixels(:,1));
maxCX = max(pixels(:,1));
minCY = min(pixels(:,2));
maxCY = max(pixels(:,2));



%%%%% DISEGNO
%%% COLORS
COLOR_ANCHOR_BP           = [0.7 0 0];             % DARK RED
COLOR_PIXELS              = [0.5 0.5 0.5];         % GRAY
COLOR_FALSE_TRACE_POINTS  = [0.9 0.5 0];           % ORANGE
COLOR_BACKGROUND          = [1 1 1];               % WHITE
COLOR_CLUSTER_CENTER      = [0.2 0.2 0.8];         % BLUE
COLOR_INTERNAL_ANGLES     = [0.2 0.2 0.8];         % BLUE
COLOR_EXTERNAL_ANGLES     = [0,0.8,0];             % GREEN
COLOR_TEXT                = [1 1 1];               % WHITE



%%% DISEGNO L'IMMAGINE 
rows = maxCX+offset;
cols = maxCY+offset;
img = ones(rows, cols, 3); 
for i = 1 : rows
   for j = 1 : cols
       img(i, j, :) = COLOR_BACKGROUND;
   end
end


%%% DISEGNO I PX SULL'IMMAGINE
[lengthCluster, ~] = size(pixels);
for i = 1 : lengthCluster
    img(pixels(i,1), pixels(i,2), :) = COLOR_PIXELS;
end

%%% DISEGNO GLI ANCHOR BP SULL'IMMAGINE
for i = 1 : clusterRank
    img(anchorBP(i,1), anchorBP(i,2), :) = COLOR_ANCHOR_BP; 
end

%%% DISEGNO I FALSE TRACE POINTS SULL'IMMAGINE
[lengthFalseTracePoints, ~] = size(falseTracePoints);
for i = 1 : lengthFalseTracePoints
    img(falseTracePoints(i,1), falseTracePoints(i,2), :) = COLOR_FALSE_TRACE_POINTS;
end


% inizializzo figura
figure('units', 'normalized', 'outerposition', [0 0 1 1]), 
% disegno l'immagine
imagesc(img), colormap(gray), hold on, axis equal
% disegno il cluster center
% plot(clusterCenter(2), clusterCenter(1), 'ro', 'MarkerSize', 8, 'MarkerEdgeColor', COLOR_CLUSTER_CENTER, 'MarkerFaceColor', COLOR_CLUSTER_CENTER);
% disegno il cerchio
% plot(ycirc, xcirc, 'Color', COLOR_INTERNAL_ANGLES)
% testo anchorBP, linee angoli interni, linee angoli esterni 
for i = 1 : clusterRank
    line([anchorBP(i,2) exitDir(i,2)], [anchorBP(i,1) exitDir(i,1)], 'Color', COLOR_EXTERNAL_ANGLES);
    plot(exitDir(i,2), exitDir(i,1), 'ro', 'MarkerSize', 8, 'MarkerEdgeColor', COLOR_EXTERNAL_ANGLES, 'MarkerFaceColor', COLOR_EXTERNAL_ANGLES);
%     line([clusterCenter(2) internalDir(i,2)], [clusterCenter(1) internalDir(i,1)], 'Color', COLOR_INTERNAL_ANGLES);
%     plot(internalDir(i,2), internalDir(i,1), 'ro', 'MarkerSize', 4, 'MarkerEdgeColor', COLOR_INTERNAL_ANGLES, 'MarkerFaceColor', COLOR_INTERNAL_ANGLES);
    text(anchorBP(i,2), anchorBP(i,1), num2str(i), 'FontSize', 12, 'FontWeight', 'bold', 'Color', COLOR_TEXT);
end
axis([minCY-offset maxCY+offset, minCX-offset maxCX+offset]);


%%% INFORMAZIONI
% Disegno le informazioni del cluster in alto a sinistra
dimDesc = [0.002 1 1 0];
dimRes = [0.112 1 1 0];
strDesc = {'InternalAngles:   '; 'ExternalAngles:    '; 'InternalAnglesFrom0: '; 'adiacency: '};
strRes = {num2str(internalAngles); num2str(externalAngles); num2str(internalAnglesFrom0); num2str(adiacency); num2str(dijkstraCurvatures')};
annotation('textbox', dimDesc, 'String', strDesc, 'FitBoxToText', 'on', 'LineStyle', 'none', 'FontWeight', 'bold');
annotation('textbox', dimRes, 'String', strRes, 'FitBoxToText', 'on', 'LineStyle', 'none');


%%% LEGENDA
dimDesc = [0.89 1 1 0];
strDesc = {'CLUSTER POINTS'; 'ANCHOR POINTS'; 'FALSE TRACE POINTS'; 'EXTERNAL ANGLES'; 'INTERNAL ANGLES'};
annotation('textbox', dimDesc, 'String', strDesc, 'FitBoxToText', 'on', 'LineStyle', 'none', 'FontWeight', 'bold');

DOWN_OFFSET = 0.023;
dimPixels = [0.88 1 1 0];
dimAnchorBP = [0.88 1-DOWN_OFFSET*1 1 0];
dimFalseTracePoints = [0.88 1-DOWN_OFFSET*2 1 0];
dimExternalAngles = [0.88 1-DOWN_OFFSET*3 1 0];
dimInternalAngles = [0.88 1-DOWN_OFFSET*4 1 0];
strPoint = {'•'};
annotation('textbox', dimPixels, 'String', strPoint, 'FitBoxToText', 'on', 'LineStyle', 'none', 'FontWeight', 'bold', 'Color', COLOR_PIXELS);
annotation('textbox', dimAnchorBP, 'String', strPoint, 'FitBoxToText', 'on', 'LineStyle', 'none', 'FontWeight', 'bold', 'Color', COLOR_ANCHOR_BP);
annotation('textbox', dimFalseTracePoints, 'String', strPoint, 'FitBoxToText', 'on', 'LineStyle', 'none', 'FontWeight', 'bold', 'Color', COLOR_FALSE_TRACE_POINTS);
annotation('textbox', dimExternalAngles, 'String', strPoint, 'FitBoxToText', 'on', 'LineStyle', 'none', 'FontWeight', 'bold', 'Color', COLOR_EXTERNAL_ANGLES);
annotation('textbox', dimInternalAngles, 'String', strPoint, 'FitBoxToText', 'on', 'LineStyle', 'none', 'FontWeight', 'bold', 'Color', COLOR_INTERNAL_ANGLES);

end