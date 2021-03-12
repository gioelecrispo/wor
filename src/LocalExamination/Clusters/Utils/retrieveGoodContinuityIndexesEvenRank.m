function pairedIndexes = retrieveGoodContinuityIndexesEvenRank(numPaths, clusterIndex, image, clusters, options)


%%% OTTENGO LE DISTANZE TRA LE EXIT DIRECTIONS
% Esamino tutte le combinazioni ed eseguo la differenza tra gli angoli
% interni e quelli esterni a partire da 0. Inoltre, tramite Dijkstra si
% computa la distanza in pixels tra i vari anchor BP.
%%%% 
%[image, clusters] = computeExitBranchesContributions(clusterIndex, image, clusters, options);
combinations = clusters(clusterIndex).branchesCombinations;
externalAnglesDistances = clusters(clusterIndex).externalAnglesDistances;
internalAnglesDistances = clusters(clusterIndex).internalAnglesDistances;
dijkstraCurvatures = clusters(clusterIndex).dijkstraCurvatures;


%%% TROVO GLI INDICI DEGLI ANCHOR BP DA ACCOPPIARE PER BUONA CONTINUITA'
% Tenendo conto sia degli angoli esterni che degli angoli interni a partire
% da 0; ogni volta che viene fatta un associazione si aggiornano le matrici
% combinations, externalAnglesDistances, internalAnglesDistances, in modo
% da escludere i vertici già accoppiati.
pairedIndexes = computePairedIndexes(numPaths, combinations, externalAnglesDistances, internalAnglesDistances, dijkstraCurvatures, WeightedVote.GENERAL);



end