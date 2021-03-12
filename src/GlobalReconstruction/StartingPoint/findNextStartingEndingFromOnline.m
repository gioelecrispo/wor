function [starter, ender, index] = findNextStartingEndingFromOnline(startingPoint, endingPoints, image, index)
% Cerca un nuovo punto di partenza (starter) per il prossimo trace
% following. In un immagine si possono avere più componenti separate, e
% quindi più endPoints. Il criterio di scelta si basa sulla vicinanza
% rispetto all'ultimo sbrogliato del tratto precedente.

[lengthStartingPoints, ~] = size(startingPoint);
index = index + 1;
starter = [];
ender = [];
if index <= lengthStartingPoints 
    starter = startingPoint(index,:);
    ender = endingPoints(index,:);
end


end