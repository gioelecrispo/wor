function mean = circularMean(angles, weightedArray)
% La funzione calcola la media circolare dato un vettore di angoli in
% input, angles. Il risultato è l'angolo "medio". Corrisponde alla media
% aritmetica; in questo caso però bisogna tenere conto della periodicità
% degli angoli. Infine normalizziamo il risultato affinchè sia nel range
% [0, 360].

if nargin == 1 
    % ho solo gli angoli
    s = sum(sind(angles))/length(angles);
    c = sum(cosd(angles))/length(angles);

    mean = atan2d(s,c);
else
    % ho anche i pesi
    lengthWeightedArray = length(weightedArray);
    weightedsin = zeros(1, lengthWeightedArray);
    weightedcos = zeros(1, lengthWeightedArray);

    for i = 1 : lengthWeightedArray
        weightedsin(i) = sind(angles(i))*weightedArray(i);
        weightedcos(i) = cosd(angles(i))*weightedArray(i);
    end
    
    mean = atan2d(sum(weightedsin), sum(weightedcos));
end


% Siccome il risultato di atan2d è -180 <= res <= 180, lo normalizziamo
% alla circonferenza da 0 a 360 per questioni di semplicità.
if mean < 0
   mean = mean + 360;
end




end