function fig = drawOnlineAndRecoveredTrajectory(bw, online8conn, unfolder, result)

name = 'drawOnlineAndRecoveredTrajectory';
%%% INIZIALIZZAZIONE DATA
% Rimuovo i pen-ups
nanIndexes = isnan(online8conn.x_8c);
online8conn.x_8c(nanIndexes) = [];
online8conn.y_8c(nanIndexes) = [];
online8conn.ep_8c(nanIndexes) = [];

onlineX = online8conn.x_8c; % - 43;   % 43: OFFSET SALERNO SKEL
onlineY = online8conn.y_8c; % - 43;   % 43: OFFSET SALERNO SKEL
recoveredX = unfolder.unfoldedArray(:,2); % recovered.x;
recoveredY = unfolder.unfoldedArray(:,1); %recovered.y;

% Calcolo velocità di default
lengthOnline = length(onlineX);
lengthRecovered = length(recoveredX);
drawingPercentage = 0.002;
drawingSpeedOnline = round(lengthOnline*drawingPercentage);
drawingSpeedRecovered = round(lengthRecovered*drawingPercentage);

%%% FIGURE
fig = figure('units','normalized','outerposition',[0 0 1 1]);
fig.Name = name;
subplot(1,2,1), imagesc(bw); colormap(gray); hold on; title('Online 8-conn');
subplot(1,2,2), imagesc(bw); colormap(gray); hold on; title('Recovered');
dimDesc = [0.468 0.99 1 0];
dimRes = [0.53 0.99 1 0];
strDesc = {'RMSE:   '; 'DTW:    '; 'SNR:    '; 'RCP:    '};
strRes = {num2str(result.rmse, 3); num2str(result.dtw, 3); num2str(result.snr, 3); num2str(result.rcp, 3)};
annotation('textbox', dimDesc, 'String', strDesc, 'FitBoxToText', 'on', 'LineStyle', 'none', 'FontWeight', 'bold');
annotation('textbox', dimRes, 'String', strRes, 'FitBoxToText', 'on', 'LineStyle', 'none');
drawnow



aon = 1;
arc = 1;
endedOnline = false;
endedRecovered = false;
while ~endedOnline || ~endedRecovered
    if ~endedOnline
        bon = aon + drawingSpeedOnline;
        if bon >= lengthOnline
            endedOnline = true;
            bon = lengthOnline;
        end
        subplot(1,2,1),
        plot(onlineX(aon:bon), onlineY(aon:bon), 'r.');
        aon = bon;
    end
    if ~endedRecovered
        brc = arc + drawingSpeedRecovered;
        if brc >= lengthRecovered
            endedRecovered = true;
            brc = lengthRecovered;
        end
        subplot(1,2,2),
        plot(recoveredX(arc:brc), recoveredY(arc:brc), 'r.');
        arc = brc;
    end
    drawnow;
end





