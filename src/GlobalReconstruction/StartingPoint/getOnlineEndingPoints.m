function endingPoints = getOnlineEndingPoints(online8conn)

%%% Initializing variables
p = online8conn.ep_8c;        % pressure
x = online8conn.x_8c;         % x coordinate
y = online8conn.y_8c;         % y coordinate

%%% Initializing ending points
endingPoints = [];


%%% Finding ending point
% Finding the last point of the pen-down, i.e. the last point before p > 0.
ep = p;
endCondition = true;
while endCondition
    press0_i = find(ep == 0, 1);
    if ~isempty(press0_i)
        ep(1:press0_i) = NaN;
        press0_f = find(ep > 0, 1) - 1;
        ep(press0_i:press0_f) = NaN;
        endingPoints = [endingPoints; y(press0_i-1), x(press0_i-1)];
    else
        endCondition = false;
    end
end

%%% FINDING LAST ENDING POINT
if (ep(end) == 1) 
   endingPoints = [endingPoints; y(end), x(end)];
end

end