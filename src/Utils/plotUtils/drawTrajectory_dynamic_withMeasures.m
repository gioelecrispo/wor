%% drawTrajectory
% offset defines the speed with which draw the trajectory.
function fig = drawTrajectory_dynamic_withMeasures(image, clusters, unfolder, data, options, results, SPEED_OFFSET, PLOT_PERSISTENT)

name = 'drawTrajectory_dynamic_withMeasures';
recovered.x = unfolder.unfoldedArray(:,2);
recovered.y = unfolder.unfoldedArray(:,1);
x_8c = recovered.x;
y_8c = recovered.y;

online_withPenUps = data.online;
online8conn_withPenUps = data.online8conn;
[online, online8conn] = removePenUps(online_withPenUps, online8conn_withPenUps);



% Set default speed
if ~exist('SPEED_OFFSET', 'var')
    SPEED_OFFSET = 50;
end

% Initialize figure
Ic2 = image.bw;
fig = figure('units','normalized','outerposition', [0 0 1 1]);
fig.Name = name;
imagesc(Ic2), colormap(gray), drawnow;
hold on

% Define image size
[height, width] = size(Ic2);

% Define colors
COLOR_PEN_TIP = [1, 0, 0];
COLOR_TEXT = [0, 0, 0];

% Define Text constants
TEXT_FONT_SIZE = 18;
TEXT_LEFT_START = width * 0.0185; %15;
TEXT_LEFT_OFFSET = width * 0.0735; %60;
TEXT_TOP_START = height * 0.045; %30;
TEXT_TOP_OFFSET = height * 0.045; %30;
TEXT_BOTTOM_START = height - (height * 0.045); %height - 30;


%title(strcat('Database: ', options.databasepath, ' • writer: ', num2str(options.writer), ' - signature: ', strcat(' ', num2str(options.signature))), 'FontSize', TEXT_FONT_SIZE);

complexityText = 'medium';
if results.complexity < 4
   complexityText = 'low';
elseif results.complexity > 6.6
    complexityText = 'high';
end

complexityLabelText = text(TEXT_LEFT_START, TEXT_BOTTOM_START, 'Complexity: ', 'FontSize', TEXT_FONT_SIZE, 'FontWeight', 'bold', 'Color', COLOR_TEXT);
complexityValueText = text(TEXT_LEFT_START + 2*TEXT_LEFT_OFFSET, TEXT_BOTTOM_START, complexityText, 'FontSize', TEXT_FONT_SIZE, 'FontWeight', 'bold', 'Color', COLOR_TEXT);


PLOT_DELETER_OFFSET = 2;
plotCounter = 1;
a = 1;
for kk = 1 : SPEED_OFFSET : length(x_8c) - SPEED_OFFSET
    b = a + SPEED_OFFSET;

    if plotCounter > PLOT_DELETER_OFFSET
        delete(h_dynamic(plotCounter - PLOT_DELETER_OFFSET));
        if PLOT_PERSISTENT
            set(h_static(plotCounter - PLOT_DELETER_OFFSET), 'Visible', 'on');         
        end
    end
    if exist('snrLabelText', 'var')
        delete(snrLabelText);
    end
    if exist('rmseLabelText', 'var')
        delete(rmseLabelText);
    end
    if exist('dtwLabelText', 'var')
        delete(dtwLabelText);
    end
     if exist('snrValueText', 'var')
        delete(snrValueText);
    end
    if exist('rmseValueText', 'var')
        delete(rmseValueText);
    end
    if exist('dtwValueText', 'var')
        delete(dtwValueText);
    end
    
    try
        signatureLength = length(online8conn.y_8c(1:b));
    catch Exception
        b = length(online8conn.y_8c);
        signatureLength = length(online8conn.y_8c(1:b));
    end
    %%% COORDINATES NORMALIZATION
    % Coordinate recovered (mie coordinate)
    [recovered_norm.x, recovered_norm.y] = normalizeCoordinates(recovered.x(1:b), recovered.y(1:b), signatureLength);
    % Coordinate reale (traiettoria 8-conn derivante dai dati online)
    [online8conn_norm.x, online8conn_norm.y] = normalizeCoordinates(online8conn.x_8c(1:b), online8conn.y_8c(1:b), signatureLength);
    

    %%% EVALUATION
    % RMSE
    rmse = m_rmse(recovered_norm.x, recovered_norm.y, online8conn_norm.x, online8conn_norm.y);
    % DTW
    [C, ~, ~] = m_dtw(pdist2([recovered_norm.x, recovered_norm.y], [online8conn_norm.x, online8conn_norm.y], 'euclidean'));
    dtw = C(end,end);
    % SNR
    snr = m_SNR(recovered_norm.x, recovered_norm.y, online8conn_norm.x, online8conn_norm.y);
    
    snrLabelText = text(TEXT_LEFT_START, TEXT_TOP_START + 0*TEXT_TOP_OFFSET, strcat('SNR: '), 'FontSize', TEXT_FONT_SIZE, 'FontWeight', 'bold', 'Color', COLOR_TEXT);
    rmseLabelText = text(TEXT_LEFT_START, TEXT_TOP_START + 1*TEXT_TOP_OFFSET, strcat('RMSE: '), 'FontSize', TEXT_FONT_SIZE, 'FontWeight', 'bold', 'Color', COLOR_TEXT);
    dtwLabelText = text(TEXT_LEFT_START, TEXT_TOP_START + 2*TEXT_TOP_OFFSET, strcat('DTW: '), 'FontSize', TEXT_FONT_SIZE, 'FontWeight', 'bold', 'Color', COLOR_TEXT);
    snrValueText = text(TEXT_LEFT_START + TEXT_LEFT_OFFSET, TEXT_TOP_START + 0*TEXT_TOP_OFFSET, strcat(num2str(round(snr,2))), 'FontSize', TEXT_FONT_SIZE, 'FontWeight', 'bold', 'Color', COLOR_TEXT);
    rmseValueText = text(TEXT_LEFT_START + TEXT_LEFT_OFFSET, TEXT_TOP_START + 1*TEXT_TOP_OFFSET, strcat(num2str(round(rmse,2))), 'FontSize', TEXT_FONT_SIZE, 'FontWeight', 'bold', 'Color', COLOR_TEXT);
    dtwValueText = text(TEXT_LEFT_START + TEXT_LEFT_OFFSET, TEXT_TOP_START + 2*TEXT_TOP_OFFSET, strcat(num2str(round(dtw,2))), 'FontSize', TEXT_FONT_SIZE, 'FontWeight', 'bold', 'Color', COLOR_TEXT);
    
    h_dynamic(plotCounter) = plot(x_8c(a:b), y_8c(a:b), 'r.');
    h_static(plotCounter) = plot(x_8c(a:b), y_8c(a:b), 'b.', 'Visible', 'off');
    
    drawnow;
    
    if exist('h_penTip', 'var')
        delete(h_penTip);
    end
    
    h_penTip = plot(x_8c(b), y_8c(b), 'ro', 'MarkerSize', 8, 'MarkerEdgeColor', COLOR_PEN_TIP, 'MarkerFaceColor', COLOR_PEN_TIP);
    plotCounter = plotCounter + 1;
    drawnow;
    a = b;
end



delete(h_dynamic(plotCounter - PLOT_DELETER_OFFSET:end));
delete(h_penTip);

if PLOT_PERSISTENT
    set(h_static(plotCounter - PLOT_DELETER_OFFSET:end), 'Visible', 'on');
    b = length(x_8c);
    plot(x_8c(a:b), y_8c(a:b), 'b.');
end


drawnow;

end

