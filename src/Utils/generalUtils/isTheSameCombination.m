function bool = isTheSameCombination(comb1, comb2)

%%% COMBINAZIONI DI LUNGHEZZA 2
% Verifica se i numeri sono gli stessi, in qualsiasi ordine
% [1 3] == [1 3]  -->  true
% [1 3] == [3 1]  -->  true
% [1 3] == [2 3]  -->  false

[~, lengthComb1] = size(comb1);
[~, lengthComb2] = size(comb2);
if lengthComb1 ~= 2 && lengthComb2 ~= 2
    error('ISTHESAMECOMBINATION: length error.');
end

bool = (comb1(1) == comb2(1) && comb1(2) == comb2(2)) || ... 
   (comb1(1) == comb2(2) && comb1(2) == comb2(1));


end