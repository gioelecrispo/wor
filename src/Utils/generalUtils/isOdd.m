function bool = isOdd(number)
% isOdd è una funzione che verifica se il numero in input è DISPARI.
% Restituisce TRUE se è DISPARI. (altrimenti è PARI)

bool = mod(number, 2) == 1;

end