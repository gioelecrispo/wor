function [image, clusters, association] = processMarriedCluster(clusterIndex, image, clusters, options)

logger = getLogger(options);
logger.info('Processing married cluster: %d', clusterIndex);

%%% OTTENIMENTO INFORMAZIONI CLUSTER
pixels = clusters(clusterIndex).pixels;
anchorBP = clusters(clusterIndex).anchorBP;
exitDirections = clusters(clusterIndex).exitDirections;
clusterRank =  clusters(clusterIndex).clusterRank;
adiacency = clusters(clusterIndex).adiacency;
internalAngles = clusters(clusterIndex).internalAngles;
internalAnglesFrom0 = clusters(clusterIndex).internalAnglesFrom0;
externalAngles = clusters(clusterIndex).externalAngles;

%%% ASSOCIATION
association = [];

%%% GESTIONE >--< PATTERN
% Per prima cosa analizzo le uscite del cluster alla ricerca del
% cluster più vicino; una volta trovato ne computo tutte le
% informazioni disponibili, cioè angoli interni ed esterni etc.


maxImageDim = max(image.dimensions);
[~, indexesCluster, pxDistances, associatedBPIndexes, pointsArray] = findNearestClusters_rank3(clusterIndex, image, clusters, options);
goodContinuityRank = NaN(clusterRank, 1);
pairsAssociation = NaN(clusterRank, 4);
for i = 1 : length(indexesCluster)
    if ~isnan(indexesCluster(i)) && pxDistances(i) < floor(Thresholds.MARRIED_MAX_SEGMENT_LENGTH)
        [goodContinuityValues, pairs] = evaluateSimilarityByGoodContinuity(clusterIndex, indexesCluster(i), associatedBPIndexes(i,:), pointsArray{i}, image, clusters, options);
        goodContinuityRank(i) = getGoodContinuityRank(goodContinuityValues);
        pairsAssociation(i,:) = [pairs(1,:), pairs(2,:)];
    end
    if goodContinuityRank(i) > floor(Thresholds.MARRIED_MAX_GOOD_CONTINUITY_DEGREE)
        indexesCluster(i) = NaN;
    end
end
deletingElements = isnan(indexesCluster);
indexesCluster(deletingElements) = [];
goodContinuityRank(deletingElements) = [];
pxDistances(deletingElements) = [];
associatedBPIndexes(deletingElements,:) = [];
pairsAssociation(deletingElements,:) = [];
ownIndex = ones(length(indexesCluster), 1)*clusterIndex;
association = [ownIndex indexesCluster goodContinuityRank pxDistances associatedBPIndexes pairsAssociation];



end



