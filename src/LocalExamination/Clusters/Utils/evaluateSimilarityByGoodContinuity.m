function [goodContinuityValues, pairs] = evaluateSimilarityByGoodContinuity(clusterIndex1, clusterIndex2, associatedBPIndexes, connectingArray, image, clusters, options)

%%% INIZIALIZZAZIONE
BPIndex1 = associatedBPIndexes(1);
BPIndex2 = associatedBPIndexes(2);


%%% OTTENIMENTO INFORMAZIONI CLUSTER 1
clusterRank = clusters(clusterIndex1).clusterRank;
pixels1 = clusters(clusterIndex1).pixels;
falseTracePoints1 = clusters(clusterIndex1).falseTracePoints;
clusterPoints1 = [pixels1; falseTracePoints1];
anchorBP1 = clusters(clusterIndex1).anchorBP;
exitDirections1 = clusters(clusterIndex1).exitDirections;
externalAngles1 = clusters(clusterIndex1).externalAngles;
internalAnglesFrom01 = clusters(clusterIndex1).internalAnglesFrom0;
adiacency1 = clusters(clusterIndex1).adiacency;
graph1 = clusters(clusterIndex1).graph;
[~, rute1] = dijkstra(graph1);


%%% OTTENIMENTO INFORMAZIONI CLUSTER 2
pixels2 = clusters(clusterIndex2).pixels;
falseTracePoints2 = clusters(clusterIndex2).falseTracePoints;
clusterPoints2 = [pixels2; falseTracePoints2];
anchorBP2 = clusters(clusterIndex2).anchorBP;
exitDirections2 = clusters(clusterIndex2).exitDirections;
externalAngles2 = clusters(clusterIndex2).externalAngles;
internalAnglesFrom02 = clusters(clusterIndex2).internalAnglesFrom0;
adiacency2 = clusters(clusterIndex2).adiacency;
graph2 = clusters(clusterIndex2).graph;
[~, rute2] = dijkstra(graph2);



%%% CONTROLLO ASSOCIAZIONI
%
%  1  \                     / 2
%      \____ 3      1 _____/ 
%      /                   \
%  2  /                     \ 3
% 
%  Cluster 1         Cluster 2
%
%                       Cluster 1     Cluster 2
%   SharedIndexes:          3      -      1
%   ConnectedIndexes:       2      -      2
%                           1      -      3
%
% Per essere perfettemente in linea con il pattern mostrato, i
% connectedIndexes non devono distare meno di 90 gradi dallo sharedIndex.
% Quindi, per il cluster 1, la differenza di angolo tra 1 e 3 deve essere 
% minore  di 90°. Allo stesso modo la differenza 2 e 3.
% Analogamente per il cluster 2.
% Se ciò non si verifica, il pattern non è perfettamente rispettato e le
% probabilità che l'associazione sia corretta scendono. Questo si
% concretizza nell'aumentare i pesi associati a ciascun ramo che non
% soddisfa questa associazione.
otherIndexes1 = 1 : clusterRank;
otherIndexes1(BPIndex1) = [];
otherIndexes2 = 1 : clusterRank;
otherIndexes2(BPIndex2) = [];
otherAnglesDistances1 = zeros(1, clusterRank-1);
otherAnglesDistances2 = zeros(1, clusterRank-1);
notRespectedPattern = zeros(clusterRank-1, clusterRank-1);
for i = 1 : clusterRank - 1
    otherAnglesDistances1(i) = angdiffd(externalAngles1(BPIndex1), externalAngles1(otherIndexes1(i)));
    otherAnglesDistances2(i) = angdiffd(externalAngles2(BPIndex2), externalAngles2(otherIndexes2(i)));
    if otherAnglesDistances1(i) < 90
        notRespectedPattern(i,1) = 1;
    end
    if otherAnglesDistances2(i) < 90
        notRespectedPattern(i,2) = 1;
    end
end



%%% COSTRUZIONE CLUSTER RANK 4
% Si prendono le informazioni dei due cluster, escludendo quelle sugli
% shared indexes, e si costruisce un cluster di rango 4.
% Si ottengono: 
% - anchorBP
% - exitDirections
% - externalAngles
% - internalAngles
% - rami di uscita per le Dijkstra Curvatures
anchorBP_integrated = [anchorBP1(otherIndexes1,:); anchorBP2(otherIndexes2,:)];
exitDirections_integrated = [exitDirections1(otherIndexes1,:); exitDirections2(otherIndexes2,:)];
externalAngles_integrated = [externalAngles1(otherIndexes1), externalAngles2(otherIndexes2)];
internalAngles_integrated = [internalAnglesFrom01(otherIndexes1), internalAnglesFrom02(otherIndexes2)];

% RAMI DI USCITA
exitBranches = cell(1, (clusterRank-1)*2);
for i = 1 : (clusterRank-1)*2
    exitDirection = exitDirections_integrated(i,:);
    starter = anchorBP_integrated(i,:) + exitDirections_integrated(i,:); 
    [~, unfoldedArray, ~] = traceFollowing_local(image, clusters, options, starter, exitDirection, Thresholds.NUM_PIXELS_EXPLORATION); 
    exitBranches{i} = unfoldedArray;
end


%%% COMPUTAZION PAIRED_INDEXES
combinations = [1 3;  1 4;  2  3;  2  4];
[lengthCombinations, ~] = size(combinations);
externalAnglesDistances_integrated = zeros(1, lengthCombinations);
internalAnglesDistances_integrated = zeros(1, lengthCombinations);
dijsktraCurvatures_integrated = zeros(1, lengthCombinations);
for k = 1 : lengthCombinations
    i = combinations(k,1);
    j = combinations(k,2);
    
    % ANGOLI ESTERNI
    externalAnglesDistances_integrated(k) = angdiffd(externalAngles_integrated(i), externalAngles_integrated(j));
    
    % ANGOLI INTERNI
    internalAnglesDistances_integrated(k) = angdiffd(internalAngles_integrated(i), internalAngles_integrated(j));
    
    % DIKSTRA CURVATURE
    source1 = anchorBP_integrated(i,:);
    source2 = anchorBP_integrated(j,:);
    destination1 = anchorBP1(BPIndex1,:);
    destination2 = anchorBP2(BPIndex2,:);
    
    dijkstraPath1 = retrievePathFromDijkstra_noWeightUpdate(rute1, clusterPoints1, source1, destination1);
    dijkstraPath2 = retrievePathFromDijkstra_noWeightUpdate(rute2, clusterPoints2, source2, destination2);
    curvePoints = [exitBranches{i}(end:-1:1,:); dijkstraPath1; connectingArray; dijkstraPath2(end:-1:1,:); exitBranches{j}];
    [lengthSegment, ~] = size(curvePoints);
    [multiscaleCurvature, directions, ~]  = evaluateCurvatureMultiscale(curvePoints, lengthSegment, Thresholds.CURVATURE_AROUNDNESS);
    dijsktraCurvatures_integrated(k) = multiscaleCurvature;
end


numPaths = 2;
pairedIndexes = computePairedIndexes(numPaths, combinations, externalAnglesDistances_integrated, ...
    internalAnglesDistances_integrated, dijsktraCurvatures_integrated, WeightedVote.MARRIED);


%%% PAIRS
pairs = [otherIndexes1' otherIndexes2'];
pairs = pairs(pairedIndexes);

%%% GOOD_CONTINUITY VALUES
allContributes = getAllContributes(WeightedVote.MARRIED, externalAnglesDistances_integrated, internalAnglesDistances_integrated, dijsktraCurvatures_integrated);
[sortedAllContributes, ~] = sort(allContributes);
goodContinuityValues(1) = 180 - angdiffd(externalAngles1(BPIndex1), externalAngles2(BPIndex2));
goodContinuityValues(2:3) = sortedAllContributes(1:2);


%%% AGGIUSTAMENTO PESI
for i = 1 : clusterRank - 1
    incrementer = sum(notRespectedPattern(i,:));
    incrementValue = (180 - goodContinuityValues(i+1)) / 4;
    goodContinuityValues(i+1) = goodContinuityValues(i+1) + (incrementValue * incrementer);
end




end