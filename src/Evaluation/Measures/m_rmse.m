%% m_rmse
% La funzione calcola il valore RMSE date in input:
%  - xe: i valori x della traiettoria recovered
%  - ye: i valori y della traiettoria recovered
%  -  x: i valori x della traiettoria reale (8-conn)
%  -  y: i valori y della traiettoria reale (8-conn)
function val = m_rmse(xe, ye, x, y)
    s = (sum((x-xe).^2) + sum((y-ye).^2));
    val = sqrt(s/numel(x));    
end

