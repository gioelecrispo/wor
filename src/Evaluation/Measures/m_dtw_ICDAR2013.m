function d = m_dtw_ICDAR2013(x_rec, y_rec, x_o8c, y_o8c)

% It is not sure if it was used in ICDAR2013.
% Hint of Abelaali on 2018-06-06. "As far as I remember, it has been 
% computed on the norm signal, ie: sqrt (x * x + y * y) without post 
% normalization."


% [x_rec, y_rec], coordinates of the recovered signal 
%                 (normalized with NormalizationCoordenadas)
% [x_rec, y_rec], coordinates of the online 8-connected signal 
%                 (normalized with NormalizationCoordenadas)

s_rec = sqrt(x_rec.^2+y_rec.^2);
s_o8c = sqrt(x_o8c.^2+y_o8c.^2);

numBins = 50;
bins = round(linspace(1, length(s_rec), numBins));
for i = 1 : numBins - 1
    d_intermediate(i) = dtw(s_rec(bins(i):bins(i+1)), s_o8c(bins(i):bins(i+1)));
end

d = mean(d_intermediate);

