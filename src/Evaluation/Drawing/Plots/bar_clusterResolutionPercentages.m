function [] = bar_clusterResolutionPercentages(dbName, statistics, rankRange, SAVE_OUTPUT)



clusterRank_stats = cell2mat(retrieveStructureField(statistics, 'clusterRank'));
clusterRank_types = unique(clusterRank_stats);

resolved_stats = cell2mat(retrieveStructureField(statistics, 'resolved'));
for i = 1 : length(clusterRank_types)
    indexes = find((clusterRank_stats == clusterRank_types(i)) == 1);
    successRate(i) = sum(resolved_stats(indexes))/length(indexes);
end
successRate = successRate * 100;



%%% VARIABILI
% COLORS
COLOR_BAR_RED      =  [  1   0.2   0.2];
COLOR_BAR_ORANGE   =  [  1   0.6   0.2];
COLOR_BAR_GREEN    =  [0.2   0.8   0.2];
COLOR_TEXT_WHITE   =  [  1     1     1];
COLOR_TEXT_BLACK   =  [  0     0     0];

% RANGE LIMIT
% Usiamo colori differenti in base al limite.
LOWER_LIMIT = 70;
HIGHER_LIMIT = 90; 

% OFFESET 
AXIS_OFFSET_X = 0.5;
AXIS_OFFSET_Y = 5;

%%% DISEGNO 
% inizializzo figura
fig = figure('units', 'normalized', 'outerposition', [0 0 1 1]);

% DISEGNO LE BARRE
% ho diversi handles in base al numero di elementi da plottare.
if ~exist('rankRange', 'var') || isempty(rankRange) 
    rankRange = [1 length(clusterRank_types)];
elseif rankRange(2) > clusterRank_types(end)
    rankRange(2) = clusterRank_types(end);
end

rankIndexes = [];
for i = rankRange(1) : rankRange(2)
    index = find(clusterRank_types == i);
    if ~isempty(index)
        rankIndexes = [rankIndexes; index];
    end
end
for i = 1 : length(rankIndexes)
    ind = find(clusterRank_stats == clusterRank_types(rankIndexes(i)));
    numClustersByRank(i) = length(ind);
end

for ind = 1 : length(rankIndexes)
    i = rankIndexes(ind);
    % Plot one single bar as a separate bar series.
    handleToThisBarSeries(ind) = bar(clusterRank_types(i), successRate(i), 'BarWidth', 0.8);
    % Scelta del colore in base alla percentuale
    if successRate(i) < LOWER_LIMIT 
        color = COLOR_BAR_GREEN;
    elseif successRate(i) >= LOWER_LIMIT && successRate(i) <= HIGHER_LIMIT 
        color = COLOR_BAR_GREEN;
    elseif successRate(i) >= HIGHER_LIMIT
        color = COLOR_BAR_GREEN;
    end
    set(handleToThisBarSeries(ind), 'FaceColor', color, 'EdgeColor', color);
    hold on
end
% for i = rankRange(1) : rankRange(2)
%     % Plot one single bar as a separate bar series.
%     handleToThisBarSeries(i) = bar(clusterRank_types(i), successRate(i), 'BarWidth', 0.8);
%     % Scelta del colore in base alla percentuale
%     if successRate(i) < LOWER_LIMIT 
%         color = COLOR_BAR_RED;
%     elseif successRate(i) >= LOWER_LIMIT && successRate(i) <= HIGHER_LIMIT 
%         color = COLOR_BAR_ORANGE;
%     elseif successRate(i) >= HIGHER_LIMIT
%         color = COLOR_BAR_GREEN;
%     end
%     set(handleToThisBarSeries(i), 'FaceColor', color, 'EdgeColor', color);
%     hold on
% end


% DISEGNA LE PERCENTUALI ALL'INTERNO DELLE BARRE
fontSizePerc = 16; %12; -0.15 ; -0.15, -0.2
for ind = 1 : length(rankIndexes)
    i = rankIndexes(ind);
    if successRate(i) == 0
        barPercentage = sprintf('%.0f%%', successRate(i));
        text(clusterRank_types(i)-0.25, successRate(i)+5, barPercentage, 'FontSize', fontSizePerc, 'FontWeight', 'bold', 'Color', COLOR_TEXT_BLACK);
    elseif round(successRate(i)) == successRate(i)  % vedi se il numero è intero
        barPercentage = sprintf('%.0f%%', successRate(i));
        text(clusterRank_types(i)-0.25, successRate(i)/2, barPercentage, 'FontSize', fontSizePerc, 'FontWeight', 'bold', 'Color', COLOR_TEXT_WHITE);
    else
        barPercentage = sprintf('%.2f%%', successRate(i));
        text(clusterRank_types(i)-0.3, successRate(i)/2, barPercentage, 'FontSize', fontSizePerc, 'FontWeight', 'bold', 'Color', COLOR_TEXT_WHITE);
    end
end
% for i = rankRange(1) : rankRange(2)
%     if successRate(i) == 0
%         barPercentage = sprintf('%.0f%%', successRate(i));
%         text(clusterRank_types(i)-0.25, successRate(i)+5, barPercentage, 'FontSize', fontSizePerc, 'FontWeight', 'bold', 'Color', COLOR_TEXT_BLACK);
%     elseif round(successRate(i)) == successRate(i)  % vedi se il numero è intero
%         barPercentage = sprintf('%.0f%%', successRate(i));
%         text(clusterRank_types(i)-0.25, successRate(i)/2, barPercentage, 'FontSize', fontSizePerc, 'FontWeight', 'bold', 'Color', COLOR_TEXT_WHITE);
%     else
%         barPercentage = sprintf('%.2f%%', successRate(i));
%         text(clusterRank_types(i)-0.3, successRate(i)/2, barPercentage, 'FontSize', fontSizePerc, 'FontWeight', 'bold', 'Color', COLOR_TEXT_WHITE);
%     end
% end

% GESTIONE ASSI E TITOLO IMMAGINE
fontSize = 16; %12
caption = sprintf(['Cluster resolution percentage - ' dbName]);
title(caption, 'FontSize', fontSize);
xlabel('cluster rank', 'FontSize', fontSize);
ylabel('resolution percentage', 'FontSize', fontSize);

% Restore the x and y tick marks.
xticks(rankRange(1) : rankRange(end));
yticks(0 : 10 : 100);
axis([rankRange(1)-AXIS_OFFSET_X rankRange(end)+AXIS_OFFSET_X, 0 max(successRate)+AXIS_OFFSET_Y])

% LEGENDA
dimDesc = [0.01 1 1 0];
strDesc = {'LOW: 0% < X < 70%'; 'MEDIUM: 70% < X < 90%'; 'HIGH: 90% < X < 100%'};
annotation('textbox', dimDesc, 'String', strDesc, 'FitBoxToText', 'on', 'LineStyle', 'none', 'FontWeight', 'bold');

DOWN_OFFSET = 0.022;
dimRC = [0.002 1 1 0];
dimOC = [0.002 1-DOWN_OFFSET*1 1 0];
dimGC = [0.002 1-DOWN_OFFSET*2 1 0];
strPoint = {'•'};
annotation('textbox', dimRC, 'String', strPoint, 'FitBoxToText', 'on', 'LineStyle', 'none', 'FontWeight', 'bold', 'Color', COLOR_BAR_RED);
annotation('textbox', dimOC, 'String', strPoint, 'FitBoxToText', 'on', 'LineStyle', 'none', 'FontWeight', 'bold', 'Color', COLOR_BAR_ORANGE);
annotation('textbox', dimGC, 'String', strPoint, 'FitBoxToText', 'on', 'LineStyle', 'none', 'FontWeight', 'bold', 'Color', COLOR_BAR_GREEN);

set(gca,'fontsize', fontSize)

%%% SALVO LA FIGURA
if SAVE_OUTPUT
    saveas(fig, ['Results/Data/' dbName 'clustersResolutionPercentages'], 'tif');
end

end
