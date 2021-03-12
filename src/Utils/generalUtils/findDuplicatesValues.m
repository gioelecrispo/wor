function [repeatedCount, repeatedIndex, uniqueVals] = findDuplicatesValues(values)
% Trova i valori unici
uniqueVals = unique(values);
% Conta il numero di istanze di ognuno dei valori unici
valCount = hist(values, uniqueVals);
valCount(valCount == 0) = [];

% Trova gli indici che hanno più di un occorrenza e seleziona i duplicati
repeatedIndex = [];
duplicatedIndexes = valCount > 1;
repeatedCount = valCount(duplicatedIndexes);
if ~isempty(repeatedCount)
    repeatedIndex = uniqueVals(duplicatedIndexes);
end

end