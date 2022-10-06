%% drawTrajectory
% offset defines the speed with which draw the trajectory.
function fig = drawTrajectory_dynamic(Ic2, y_8c, x_8c, SPEED_OFFSET, PLOT_PERSISTENT)

name = 'drawTrajectory_dynamic';
%%% IMPOSTA VELOCITA' DI DEFAULT
if ~exist('SPEED_OFFSET', 'var')
    SPEED_OFFSET = 20;
end
if ~exist('PLOT_PERSISTENT', 'var')
    PLOT_PERSISTENT = 1;
end

%%% INIZIALIZZA FIGURA
fig = figure('units','normalized','outerposition', [0 0 1 1]);
fig.Name = name;
imagesc(Ic2), colormap(gray), drawnow
hold on



%%% COLORI
COLOR_PEN_TIP = [1, 0, 0];

PLOT_DELETER_OFFSET = 2;
plotCounter = 1;
a = 1;
for kk = 1 : SPEED_OFFSET : length(y_8c) - SPEED_OFFSET
    b = a + SPEED_OFFSET;

    if plotCounter > PLOT_DELETER_OFFSET
        delete(h_dynamic(plotCounter - PLOT_DELETER_OFFSET));
        if PLOT_PERSISTENT
            set(h_static(plotCounter - PLOT_DELETER_OFFSET), 'Visible', 'on');
        end
    end
    
    h_dynamic(plotCounter) = plot(y_8c(a:b), x_8c(a:b), 'r.');
    h_static(plotCounter) = plot(y_8c(a:b), x_8c(a:b), 'b.', 'Visible', 'off');
    
    if exist('h_penTip', 'var')
        delete(h_penTip);
    end
    h_penTip = plot(y_8c(b), x_8c(b), 'ro', 'MarkerSize', 8, 'MarkerEdgeColor', COLOR_PEN_TIP, 'MarkerFaceColor', COLOR_PEN_TIP);
    plotCounter = plotCounter + 1;
    drawnow
    a = b;
end



delete(h_dynamic(plotCounter - PLOT_DELETER_OFFSET:end));
delete(h_penTip);

if PLOT_PERSISTENT
    set(h_static(plotCounter - PLOT_DELETER_OFFSET:end), 'Visible', 'on');
    b = length(y_8c);
    plot(y_8c(a:b), x_8c(a:b), 'b.');
end


drawnow;



end


