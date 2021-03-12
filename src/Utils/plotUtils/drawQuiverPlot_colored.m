function fig = drawQuiverPlot_colored(unfolder)

name = 'drawQuiverPlot_colored';
x = unfolder.unfoldedArray(:,2);
y = -unfolder.unfoldedArray(:,1);
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


%%% CAMPIONAMENTO VETTORI
quantizing = 0.008;
interval = floor(length(x)*quantizing);
if interval == 0 
    interval = 1;
end
componentsCamp = cell(1, numComponents);
dComponentsCamp = cell(1, numComponents);
for i = 1 : numComponents
    comp = components{i};
    componentsCamp{i} = comp(1 : interval : end, :);
    dComponentsCamp{i} = diff(componentsCamp{i});
end




%%% DISEGNO
fig = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
fig.Name = name;
hold on
DOWN_OFFSET = 0.023;
strDesc = cell(numComponents, 1);
LEFT_OFFSET = 0.915;
positionAnnotationBackground = [LEFT_OFFSET - 0.005, 1-DOWN_OFFSET*(numComponents+2), 0.085 0.031*numComponents];
annotation('rectangle', 'Position', positionAnnotationBackground, 'Color', 'w', 'FaceColor', 'w');

for c = 1 : numComponents
    comp = components{c};
    currentColor = getColor(c);
    plot(comp(:,1), comp(:,2), 'Color', currentColor), 
    compCamp = componentsCamp{c};
    dCompCamp = dComponentsCamp{c};
    [lengthcompCamp, ~] = size(compCamp);
    for i = 1 : lengthcompCamp - 1
        quiver(compCamp(i,1), compCamp(i,2), dCompCamp(i,1), dCompCamp(i,2), 'MaxHeadSize', 1, ... 
            'LineWidth', 1.5, 'Color', currentColor, 'MarkerFaceColor', currentColor, ... 
            'MarkerSize', 240, 'AutoScale', 'off');
    end
    % Legenda
    dimDesc = [LEFT_OFFSET 1-DOWN_OFFSET*(c) 1 0];
    strDesc{c} = ['• ' 'COMP. ' num2str(c)];
    annotation('textbox', dimDesc, 'String', strDesc{c}, 'FitBoxToText', 'on', 'LineStyle', 'none', 'FontWeight', 'bold', ...
        'Color', currentColor);
end



end