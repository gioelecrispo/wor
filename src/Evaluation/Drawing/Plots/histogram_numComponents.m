function [] = histogram_numComponents(dbName, numComponentsReal, numComponentsEstimated, SAVE_OUTPUT)


%%% NUM COMPONENTS
% Histogram num components
[xr, yr] = hist(numComponentsReal, sort(unique(numComponentsReal))); 
[xe, ye] = hist(numComponentsEstimated, sort(unique(numComponentsEstimated))); 

fig = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
plot(yr, xr, 'Linewidth', 2), hold on, plot(ye, xe, '-.', 'Linewidth', 2),
title('Comparison between the estimate number of components and the real one'),
fontSize = 18; % 12
caption = sprintf(['Components number - ' dbName]);
title(caption, 'FontSize', fontSize);
legend('real', 'estimated');
maxNC = max(max(numComponentsReal), max(numComponentsEstimated));
xticks(1:1:maxNC);
xlabel('# components', 'FontSize', fontSize);
ylabel('# signature', 'FontSize', fontSize);
set(gca,'fontsize', fontSize);

%%% SALVA LA FIGURA
if SAVE_OUTPUT == true
    saveas(fig, ['Results/Data/' dbName 'numComponents_histogram'], 'tif');
end

end