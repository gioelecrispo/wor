function [] = drawOrderedCoordinates(unfolder)

x = unfolder.unfoldedArray(:,2);
y = unfolder.unfoldedArray(:,1);
dx = diff(x);
dy = diff(y);


%%% CONTROLLO PEN-UPS
xdev = abs(dx);
ydev = abs(dy);
penUpsX = find(xdev > 1);
penUpsY = find(ydev > 1);
penUps = [1; penUpsX; length(x)];



%%% CREAZIONE COMPONENTI
numComponents = length(penUps) - 1;
components = cell(1, numComponents);
for i = 1 : numComponents
    components{i} = [x(penUps(i)+1:penUps(i+1)) y(penUps(i)+1:penUps(i+1))];
end


%%% DISEGNO
figure('units', 'normalized', 'outerposition', [0 0 1 1]), hold on
DOWN_OFFSET = 0.023;
strDesc = cell(numComponents, 1);
LEFT_OFFSET = 0.915;
positionAnnotationBackground = [LEFT_OFFSET - 0.005, 1-DOWN_OFFSET*(numComponents+2), 0.085 0.031*numComponents];
annotation('rectangle', 'Position', positionAnnotationBackground, 'Color', 'w', 'FaceColor', 'w');


numPoints = length(x);
currentLength = 0;
for c = 1 : numComponents
    comp = components{c};
    lengthComp = length(comp(:,1));
    t = [currentLength+1:currentLength + lengthComp];
    currentColor = getColor(c);
    plot(t, comp(:,1), 'Color', currentColor), hold on 
    plot(t, comp(:,2), 'Color', currentColor), hold on
    % Legenda
    dimDesc = [LEFT_OFFSET 1-DOWN_OFFSET*(c) 1 0];
    strDesc{c} = ['• ' 'COMP. ' num2str(c)];
    annotation('textbox', dimDesc, 'String', strDesc{c}, 'FitBoxToText', 'on', 'LineStyle', 'none', 'FontWeight', 'bold', ...
        'Color', currentColor);
    currentLength = currentLength + lengthComp;
end
%plot(1:numPoints, x, 'Color', 'b'), hold on
%plot(1:numPoints, y, 'Color', 'r'),
legend('x', 'y'),
max_x = max(x);
max_y = max(y);
maxValue = max(max_x, max_y);
axis([0 numPoints+10 0 maxValue+10])
