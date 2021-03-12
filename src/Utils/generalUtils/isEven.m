function bool = isEven(number)
% isEven è una funzione che verifica se il numero in input è PARI.
% Restituisce TRUE se è PARI. (altrimenti è DISPARI)

bool = mod(number, 2) == 0;

end