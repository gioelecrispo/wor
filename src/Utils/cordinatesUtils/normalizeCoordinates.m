function [xn, yn] = normalizeCoordinates(x, y, signatureLength)
    % Azzero i punti in cui x y non hanno valore
    x(isnan(x))=[];
    y(isnan(y))=[];
    
    % Eseguo una spline 
    x=spline(1:length(x), x, 1/signatureLength:(length(x))/signatureLength:length(x));
    y=spline(1:length(y), y, 1/signatureLength:(length(y))/signatureLength:length(y));
    if max(x) ~= min(x)
        x = (x-min(x))/(max(x)-min(x));
    else
        x = zeros(1,length(x));
    end
    if max(y) ~= min(y)
        y = (y-min(y))/(max(y)-min(y));
    else
        y = zeros(1,length(y));
    end
    xn = x;
    yn = y;
end