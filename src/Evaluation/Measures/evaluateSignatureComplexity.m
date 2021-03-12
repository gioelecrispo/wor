function complexity = evaluateSignatureComplexity(image, clusters, options)

logger = getLogger(options);
logger.debug('Evaluating signature complexity...')

% PESI
weight_component     =  0.6;
weight_clusterRank3  =  0.3;
weight_otherRanks    =  0.1;

% NUMERO COMPONENTI
[numEndPoints, ~] = size(getEndPoints(image)); %[numEndPoints, ~] = size(image.endPoints.points);
numComponents = floor(numEndPoints/2);

% CONTEGGIO CLUSTER RANK 3 E OTHER RANK
numClusterRank3 = 0;
numOtherRanks   = 0;
[~, lengthClusters] = size(clusters);
for clusterIndex = 1 : lengthClusters
    clusterRank = clusters(clusterIndex).clusterRank;
    if clusterRank == 3
        numClusterRank3 = numClusterRank3 + 1;
    else
        numOtherRanks = numOtherRanks + 1;
    end
end


complexity = weight_component*numComponents + weight_clusterRank3*numClusterRank3 + weight_otherRanks * numOtherRanks;

logger.debug('Weights:  numComponents: %f; num3RankClusters: %f; numOtherRankClusters: %f', weight_component, weight_clusterRank3, weight_otherRanks);
logger.debug('Quantity: numComponents: %d; num3RankClusters: %d; numOtherRankClusters: %d', numComponents, numClusterRank3, numOtherRanks);

end
