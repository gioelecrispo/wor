function startingPoints = getOnlineStartingPoints(online8conn)

%%% Initializing variables
p = online8conn.ep_8c;        % pressure
x = online8conn.x_8c;         % x coordinate
y = online8conn.y_8c;         % y coordinate

%%% Defining First point
% if the first point is NaN then it is not the first point, being 
% p(1) ~= 1
startingPoints = [y(1), x(1)];
if (isnan(startingPoints(1)) && isnan(startingPoints(2)))
    startingPoints = [];
end

%%% Finding subsequents starting points
% We try to recognize where the pen-ups are. The first pressure point p > 0 
% is the next starting point.
ep = p;
endCondition = true;
while endCondition
    press0_i = find(ep == 0, 1);
    if ~isempty(press0_i)
        ep(1:press0_i) = NaN;
        press0_f = find(ep > 0, 1);
        ep(press0_i:press0_f) = NaN;
        startingPoints = [startingPoints; y(press0_f), x(press0_f)];
    else
        endCondition = false;
    end
end

end