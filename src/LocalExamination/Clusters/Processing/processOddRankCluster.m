function [image, clusters] = processOddRankCluster(clusterIndex, image, clusters, options)

logger = getLogger(options);
logger.info('Processing Odd-rand cluster: %d', clusterIndex);


%%% CREO PARENTHOOD
[image, clusters] = createParenthood(clusterIndex, image, clusters, options);

%%% RISOLVO GIA' IL CLUSTER FIGLO DI RANGO PARI
[~, lengthClusters] = size(clusters);
clusterIndex_c2 = lengthClusters;
[image, clusters] = processEvenRankCluster(clusterIndex_c2, image, clusters, options);



end