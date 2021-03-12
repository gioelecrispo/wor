function [numClustersTotal, numClustersConsidered] = bar_clusterNumber(dbName, statistics, rankRange, SAVE_OUTPUT)


clusterRank_stats = cell2mat(retrieveStructureField(statistics, 'clusterRank'));
clusterRank_types = unique(clusterRank_stats);

% DISEGNO LE BARRE
% ho diversi handles in base al numero di elementi da plottare.
numClustersByRank = zeros(clusterRank_types(end), 1);
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
numClustersByRank = zeros(length(rankIndexes), 1);
for i = 1 : length(rankIndexes)
    ind = find(clusterRank_stats == clusterRank_types(rankIndexes(i)));
    numClustersByRank(i) = length(ind);
end
numClustersTotal = length(clusterRank_stats);
numClustersConsidered = sum(numClustersByRank);

% for i = rankRange(1) : rankRange(2)
%     index = find(clusterRank_types == i);
%     if ~isempty(index)
%         ind = find(clusterRank_stats == clusterRank_types(index));
%         numClustersByRank(i) = length(ind);
%     end
% end


%%% VARIABILI
% COLORS
COLOR_BAR_BLUE     =  [ 0.2   0.4   0.8];
COLOR_TEXT_BLACK   =  [  0     0     0];

% RANGE LIMIT
% Usiamo colori differenti in base al limite.
LOWER_LIMIT = 70;
HIGHER_LIMIT = 90; 

% OFFESET 
AXIS_OFFSET_X = 0.5;
AXIS_OFFSET_Y = round(max(numClustersByRank)/20);

%%% DISEGNO 
% inizializzo figura
fig = figure('units', 'normalized', 'outerposition', [0 0 1 1]);

% DISEGNO LE BARRE
% ho diversi handles in base al numero di elementi da plottare.
for ind = 1 : length(rankIndexes)
    % Plot one single bar as a separate bar series.
    handleToThisBarSeries(ind) = bar(clusterRank_types(rankIndexes(ind)), numClustersByRank(ind), 'BarWidth', 0.8);
    % Scelta del colore in base alla percentuale
    set(handleToThisBarSeries(ind), 'FaceColor', COLOR_BAR_BLUE, 'EdgeColor', COLOR_BAR_BLUE);
    hold on
end
% for i = rankRange(1) : rankRange(2)
%     % Plot one single bar as a separate bar series.
%     handleToThisBarSeries(i) = bar(clusterRank_types(i), numClustersByRank(i), 'BarWidth', 0.8);
%     % Scelta del colore in base alla percentuale
%     set(handleToThisBarSeries(i), 'FaceColor', COLOR_BAR_BLUE, 'EdgeColor', COLOR_BAR_BLUE);
%     hold on
% end

% DISEGNA I NUMERI SOPRA LE BARRE
fontSizeNumb = 16; %12 -0.15
TEXT_OFFSET_Y = round(max(numClustersByRank)/50);
% for i = rankRange(1) : rankRange(2)
%     barClusterNumber = sprintf('%d', numClustersByRank(i));
%     text(clusterRank_types(i)-0.25, numClustersByRank(i)+TEXT_OFFSET_Y, barClusterNumber, 'FontSize', fontSizeNumb, 'FontWeight', 'bold', 'Color', COLOR_TEXT_BLACK);
% end
for ind = 1 : length(rankIndexes)
    i = clusterRank_types(rankIndexes(ind));
    barClusterNumber = sprintf('%d', numClustersByRank(ind));
    text(clusterRank_types(rankIndexes(ind))-0.25, numClustersByRank(ind)+TEXT_OFFSET_Y, barClusterNumber, 'FontSize', fontSizeNumb, 'FontWeight', 'bold', 'Color', COLOR_TEXT_BLACK);
end



% GESTIONE ASSI E TITOLO IMMAGINE
fontSize = 16; %12
caption = sprintf(['Number of clusters for each rank - ' dbName]);
title(caption, 'FontSize', fontSize);
xlabel('cluster rank', 'FontSize', fontSize);
ylabel('# clusters', 'FontSize', fontSize);

% Restore the x and y tick marks.
xticks(rankRange(1) : rankRange(2));
axis([rankRange(1)-AXIS_OFFSET_X rankRange(2)+AXIS_OFFSET_X, 0 max(numClustersByRank)+AXIS_OFFSET_Y])
set(gca,'fontsize', fontSize)

%%% SALVA LA FIGURA
if SAVE_OUTPUT == true
    saveas(fig, ['Results/Data/' dbName 'clustersRankNumber'], 'tif');
end
end