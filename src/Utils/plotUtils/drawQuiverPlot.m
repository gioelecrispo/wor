function [] = drawQuiverPlot(unfolder)

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
interval = floor(length(x)*0.0025);
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
figure('units', 'normalized', 'outerposition', [0 0 1 1]), hold on

for c = 1 : numComponents
    comp = components{c};
    plot(comp(:,1), comp(:,2), 'k'), 
    compCamp = componentsCamp{c};
    dCompCamp = dComponentsCamp{c};
    [lengthcompCamp, ~] = size(compCamp);
    for i = 1 : lengthcompCamp - 1
        quiver(compCamp(i,1), compCamp(i,2), dCompCamp(i,1), dCompCamp(i,2), 'MaxHeadSize', 1000, ... 
            'LineWidth', 1, 'Color', 'r', 'MarkerFaceColor', 'k', 'MarkerSize', 20, 'AutoScale', 'off');
    end
end



end