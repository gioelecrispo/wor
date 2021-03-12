function pairedIndexes = retrieveGoodContinuityIndexesOddRank(numPaths, clusterIndex, image, clusters, options)


%%% OTTENGO LE DISTANZE TRA LE EXIT DIRECTIONS
% Esamino tutte le combinazioni ed eseguo la differenza tra gli angoli
% interni e quelli esterni a partire da 0. Inoltre, tramite Dijkstra si
% computa la distanza in pixels tra i vari anchor BP.
%%%% 
%[combinations, externalAnglesDistances, internalAnglesDistances, dijkstraCurvature] = computeExitBranchesContributions(clusterIndex, image, clusters);
combinations = clusters(clusterIndex).branchesCombinations;
externalAnglesDistances = clusters(clusterIndex).externalAnglesDistances;
internalAnglesDistances = clusters(clusterIndex).internalAnglesDistances;
dijkstraCurvatures = clusters(clusterIndex).dijkstraCurvatures;

%%% TROVO GLI ANCHOR BP CHE FORMANO IL CLUSTER DI RANGO 3
% La prima cosa da fare è ricercare il anchorBP più vicino ad un end point
% o un cluster di rango 3. Questo perchè il cluster di di rango 3 potrebbe
% essere un RETRACING CLUSTER (se vicino all'end point), oppure un MARRIED
% CLUSTER (se vicino ad un altro cluster di rango 3).
% Se le ipotesi non sono soddisfatte, allora si cerca il gruppo di anchorBP
% che rispetta meglio la buona continuità e che condivide un vertice.
%%%%%
anchorBP = clusters(clusterIndex).anchorBP;
exitDirections = clusters(clusterIndex).exitDirections;
clusterRank = clusters(clusterIndex).clusterRank;

% RICERCA END POINTS e 3-RANK CLUSTERS VICINI
endPoints = NaN(clusterRank, 2);
pxCountersEP = NaN(clusterRank, 1);
pxCounters3R = NaN(clusterRank, 1);
clusterFoundIndexes = NaN(clusterRank, 1);
anchorBPIndexes = NaN(clusterRank, 1);
for i = 1 : clusterRank
    exitDirection = exitDirections(i,:);
    starter = anchorBP(i,:) + exitDirection;
    [endPointFound, pxCounterEP, ePoint, ~] = traceFollowing_untilEndPoint(image, clusters, options, starter, exitDirection);
    if endPointFound
        pxCountersEP(i) = pxCounterEP;
        endPoints(i,:) = ePoint;
    end
    [isRank3Found, clusterFoundIndex, pxCounter3R, ~, anchorBPIndex, ~] = traceFollowing_untilNextClusterRank3(image, clusters, options, starter, exitDirection);
    if isRank3Found
        clusterFoundIndexes(i) = clusterFoundIndex;
        pxCounters3R(i) = pxCounter3R;
        anchorBPIndexes(i) = anchorBPIndex;
    end
end
%%% SELEZIONA IL VERTICE DEL CLUSTER RANK 3 PIU' PROBABILE
% La selezione è effettuata in base al numero di pixels che lo separano
% dall'end Point / cluster di rango 3.
% Si da' priorità agli end Points.
maxImageDimension = max(image.dimensions);
[minValueEP, minIndexEP] = min(pxCountersEP);
[minValue3R, minIndex3R] = min(pxCounters3R);
if (~isnan(minValueEP) && minValueEP < (Thresholds.ODD_RANK_MAX_SEGMENT_LENGTH * maxImageDimension)/100) ...
        || (~isnan(minValue3R) && minIndex3R < (Thresholds.ODD_RANK_MAX_SEGMENT_LENGTH * maxImageDimension)/100)
    if min([minValueEP, minValue3R]) == minValueEP
        % End point è più vicino
        pivot = minIndexEP;
    else
        % Cluster di rango 3 è più vicino
        pivot = minIndex3R;
    end
else
    % Non sono stati trovati end Point / cluster di rango 3 nelle
    % vicinanze; si procede a selezionare tramite buona continuità.
    minComb = numPaths + 2;
    externalAnglesDistancesFrom180 = abs(externalAnglesDistances - 180);
    [~, sortingIndexes] = sort(externalAnglesDistancesFrom180);
    sortedCombinations = combinations(sortingIndexes,:);
    minCombExternalIndexes = sortedCombinations(1:minComb,:);
    [repeatedCount, repeatedIndex, uniqueVals] = findRepeatedValue(minCombExternalIndexes(:));
    if repeatedCount == 2
        pivot = repeatedIndex;
    else
        error('ERROR CLUSTER ODD-RANK');
    end
end

%%% RIMOZIONE COMBINAZIONI CON PIVOT
pivotIndexes = combinations(:,1) == pivot | combinations(:,2) == pivot;
[lengthCombinations, ~] = size(combinations);
mask = true(1, lengthCombinations);
mask(pivotIndexes) = 0;
combinationsWP = combinations(mask,:);
externalAnglesDistancesWP = externalAnglesDistances(mask);
internalAnglesDistancesWP = internalAnglesDistances(mask);  
dijkstraCurvatureWP = dijkstraCurvatures(mask);
numPaths = (clusterRank - 3) / 2;


% minComb = numPaths + 2;
% externalAnglesDistancesFrom180 = abs(externalAnglesDistances - 180);
% [~, sortingIndexes] = sort(externalAnglesDistancesFrom180);
% sortedCombinations = combinations(sortingIndexes,:);
% minCombExternalIndexes = sortedCombinations(1:minComb,:);
% 
% [repeatedCount, repeatedIndex, uniqueVals] = findRepeatedValue(minCombExternalIndexes(:));
% if repeatedCount == 2
%     toEliminate = minCombExternalIndexes(:,1) == repeatedIndex | minCombExternalIndexes(:,2) == repeatedIndex;
%     toEliminate = ~toEliminate;
%     uniqueVals(minCombExternalIndexes(toEliminate,:)) = [];
%     indexesClusterRank3 = uniqueVals;
%     alreadyFound = combinations(:,1)==indexesClusterRank3(1) | combinations(:,1)==indexesClusterRank3(2) | combinations(:,1)==indexesClusterRank3(3) | ...
%         combinations(:,2)==indexesClusterRank3(1) | combinations(:,2)==indexesClusterRank3(2) | combinations(:,2)==indexesClusterRank3(3);
%     [lengthCombinations, ~] = size(combinations);
%     mask = true(1, lengthCombinations);
%     mask(alreadyFound) = 0;
%     externalAnglesDistances = externalAnglesDistances(mask);
%     internalAnglesDistances = internalAnglesDistances(mask);
%     dijkstraCurvature = dijkstraCurvature(mask);
%     combinations = combinations(mask,:);
% else
%     error('ODD_RANK: cluster rank 3 not found');
% end


%%% TROVO GLI INDICI DEGLI ANCHOR BP DA ACCOPPIARE PER BUONA CONTINUITA'
% Tenendo conto sia degli angoli esterni che degli angoli interni a partire
% da 0; ogni volta che viene fatta un associazione si aggiornano le matrici
% combinations, externalAnglesDistances, internalAnglesDistances, in modo
% da escludere i vertici già accoppiati.
pairedIndexes = computePairedIndexes(numPaths, combinationsWP, externalAnglesDistancesWP, internalAnglesDistancesWP, dijkstraCurvatureWP, WeightedVote.ODD_RANK);




end