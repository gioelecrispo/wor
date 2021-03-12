function statisticalInitialPoint = retrieveStatisticalStartPoint()


statisticalInitialPointPath = 'GlobalReconstruction/StartingPoint/statisticalInitialPointComputed.mat';
if exist(statisticalInitialPointPath, 'file') == 2
    load(statisticalInitialPointPath);
else
    %% CONFIGURATION
    db = '../Database/SigComp2009/';           
    ddb = dir(db);


    fprintf('--- SELECTING INITIAL POINT BASED ON ONLINE DATA ---\n');
    fprintf('It performs a reading of all data of the online signatures in order to retrieve a "statistical" initial point.\n');
    fprintf('Starting execution...\n');


    %% EXECUTION 
    xi = [];
    yi = [];
    for ii = 1 : length(ddb)-2
        fol = ddb(ii+2).name;
        dfol = dir([db fol '/*.mat']);
        for jj = 1 : length(dfol)
            fprintf('%s\n',[fol '/' dfol(jj).name])
            load([db fol '/' dfol(jj).name]);

            % Elaborate pressure in order to understand what are pen-up and pen-down
            ep = p; ep(ep < 50) = 0; ep(ep ~= 0) = 1;
            %xnp = x; ynp = y;
            %xnp(ep==0) = NaN; 
            %ynp(ep==0) = NaN;
            %plot(x, -y, '.-r')                           % Total trajectory (pen-up & pen-down)
            %hold on; plot(xnp, -ynp, '.-b'); hold off    % Trajectory with only pen-down 

            % Normalization
            x = (x-min(x))/(max(x)-min(x));
            y = -y; 
            y = (y-min(y))/(max(y)-min(y));
            xi(end+1) = x(1); 
            yi(end+1) = y(1);

            % Registering the first point of online data
            xi(end+1) = x(1); 
            yi(end+1) = y(1);
        end

        fprintf('- End writer: %d \n', ii);
    end

    fprintf('--- END ---\n');
    
    hr = std(xi); % horizontal radius
    vr = std(yi); % vertical radius
    x0 = mean(xi); % x0,y0 ellipse centre coordinates
    y0 = mean(yi);
    statisticalInitialPoint.coordinates = [x0 y0];
    statisticalInitialPoint.radius = [hr vr];
    statisticalInitialPoint.description = 'COORDINATES (mean): [x0, y0];    RADIUS (std) = [HORIZ., VERT.]';
    save('StartPoint/statisticalInitialPointComputed.mat', 'statisticalInitialPoint');
end




end