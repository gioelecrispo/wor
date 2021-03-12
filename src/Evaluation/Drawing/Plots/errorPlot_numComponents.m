function [] = errorPlot_numComponents(dbName, errorNumComp, SAVE_OUTPUT)


fig = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
plot(errorNumComp), title('Components number error');
fontSize = 18; % 12
caption = sprintf(['Components number error - ' dbName]);
title(caption, 'FontSize', fontSize);
xlabel('signatures', 'FontSize', fontSize);
ylabel('error', 'FontSize', fontSize);
set(gca,'fontsize', fontSize);

%%% SALVA FIGURA
if SAVE_OUTPUT == true
    saveas(fig, ['Results/Data/' dbName 'numComponents_error'], 'tif');
end

