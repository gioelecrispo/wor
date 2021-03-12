function [repeatedCount, repeatedIndex, uniqueVals] = findMaxRepeatedValue(values)

% Trova i valori unici
uniqueVals = unique(values);
% Couta il numero di istanze di ognuno dei valori unici
valCount = hist(values, uniqueVals);
[repeatedCount, repeatedIndex] = max(valCount);


end