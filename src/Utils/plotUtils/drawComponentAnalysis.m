function [] = drawComponentAnalysis(image, unfolder)

COLOR_STARTING_POINT              = [0.8 0.0 0.0];             % DARK_RED
COLOR_ENDING_POINT                = [0.4 0.0 0.6];             % DARK_BLUE
COLOR_TEXT                        = [0 0 0];                   % BLACK
COLOR_ANGLES                      = [0,0.8,0];             % GREEN







% inizializzo figura
figure('units', 'normalized', 'outerposition', [0 0 1 1]),
% disegno l'immagine
imagesc(image.bw), colormap(gray), hold on,


startingPoints = cell2mat(retrieveStructureField(unfolder.components, 'starter'));
endingPoints = cell2mat(retrieveStructureField(unfolder.components, 'ender'));
startingAngles = cell2mat(retrieveStructureField(unfolder.components, 'starterDirection'));
endingAngles = cell2mat(retrieveStructureField(unfolder.components, 'enderDirection'));

lengthComponents = length(unfolder.components);

% Ottengo le exit directions
startingDir = zeros(lengthComponents, 2);
endingDir = zeros(lengthComponents, 2);
segLength = 5;                  % lunghezza del segmento uscente
for i = 1 : lengthComponents
    startingDir(i,1) = startingPoints(i,1) + segLength * cosd(startingAngles(i)+90);
    startingDir(i,2) = startingPoints(i,2) + segLength * sind(startingAngles(i)+90);
    endingDir(i,1) = endingPoints(i,1) + segLength * cosd(endingAngles(i)+90);
    endingDir(i,2) = endingPoints(i,2) + segLength * sind(endingAngles(i)+90);
end

for i = 1 : lengthComponents
    plot(startingPoints(i,2), startingPoints(i,1), 'ro', 'MarkerSize', 8, 'MarkerEdgeColor', COLOR_STARTING_POINT, 'MarkerFaceColor', COLOR_STARTING_POINT);
    text(startingPoints(i,2), startingPoints(i,1), num2str(i), 'FontSize', 8, 'FontWeight', 'bold', 'Color', COLOR_TEXT);
    
    plot(endingPoints(i,2), endingPoints(i,1), 'ro', 'MarkerSize', 8, 'MarkerEdgeColor', COLOR_ENDING_POINT, 'MarkerFaceColor', COLOR_ENDING_POINT);
    text(endingPoints(i,2), endingPoints(i,1), num2str(i), 'FontSize', 8, 'FontWeight', 'bold', 'Color', COLOR_TEXT);
    
    line([startingPoints(i,2) startingDir(i,2)], [startingPoints(i,1) startingDir(i,1)], 'Color', COLOR_STARTING_POINT, 'LineWidth', 8);
    line([endingPoints(i,2) endingDir(i,2)], [endingPoints(i,1) endingDir(i,1)], 'Color', COLOR_ENDING_POINT, 'LineWidth', 8);
end


end