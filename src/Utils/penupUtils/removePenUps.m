function [online, online8conn] = removePenUps(online_withPenUps, online8conn_withPenUps)

online = online_withPenUps;
online8conn = online8conn_withPenUps;

%%% ONLINE SENZA PEN UPs
penUpIndexes = online_withPenUps.p == 0;
online.p(penUpIndexes) = [];
if length(penUpIndexes) ~= length(online.x)
    penUpIndexes = penUpIndexes(1:length(online.x));
end
online.x(penUpIndexes) = [];
online.y(penUpIndexes) = [];


%%% ONLINE 8 CONNESSA SENZA PEN UPs
zeroIndexes = online8conn.x_8c == 0;
online8conn.x_8c(zeroIndexes) = [];
online8conn.y_8c(zeroIndexes) = [];
online8conn.ep_8c(zeroIndexes) = [];

end