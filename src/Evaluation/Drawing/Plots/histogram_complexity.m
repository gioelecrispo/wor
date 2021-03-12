function [] = histogram_complexity(dbName, complexity, divisionPoints, SAVE_OUTPUT)


%%% HISTOGRAM COMPLEXTY DISTIBUTION
fig = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
[x,y] = hist(complexity, 30);
hist(complexity, 30);
h = findobj(gca,'Type','patch');
h.FaceColor = [1 0.8 0.6];
h.EdgeColor = 'w';
hold on, plot(y, x, 'r', 'Linewidth', 2);

% Dividi in 3 parti uguali
maxHeight = max(x) + 30;
maxWidth = max(y);
line([divisionPoints(1) divisionPoints(1)], [0 maxHeight], 'Color', [0 0 1]);
line([divisionPoints(2) divisionPoints(2)], [0 maxHeight], 'Color', [0 0 1]);

% GESTIONE ASSI E TITOLO IMMAGINE
fontSize = 16; %12
caption = sprintf('Complexity distribution');
title(caption, 'FontSize', fontSize);
xlabel('complexity values', 'FontSize', fontSize);
ylabel('# signature', 'FontSize', fontSize);
yText = maxHeight - 10;

fontSizeClassComplexity = 16; 
TEXT_OFFSET_1 = divisionPoints(1)*0.1;
TEXT_OFFSET_2 = divisionPoints(1)*0.2;
xLow = divisionPoints(1)/2 - TEXT_OFFSET_1; 
xMedium = (divisionPoints(2) - divisionPoints(1))/2 + divisionPoints(1) - TEXT_OFFSET_2; 
xHigh = (maxWidth - divisionPoints(2))/2 + divisionPoints(2) - TEXT_OFFSET_1; 
text(xLow, yText, 'LOW', 'FontSize', fontSizeClassComplexity, 'FontWeight', 'bold');
text(xMedium, yText, 'MEDIUM', 'FontSize', fontSizeClassComplexity, 'FontWeight', 'bold');
text(xHigh, yText, 'HIGH', 'FontSize', fontSizeClassComplexity, 'FontWeight', 'bold');
set(gca,'fontsize', fontSize)

%%% SALVA LA FIGURA
if SAVE_OUTPUT == true
    saveas(fig, ['Results/Data/' dbName 'complexity_histogram'], 'tif');
end

end