function [image, clusters] = detectCluster(image, options)

logger = getLogger(options);
logger.info('--> Detecting Clusters...');

%%% CLUSTERS DETECTION
% Extracting the connected components of the image in order to obtain all
% the clusters of branch points.
[image, clusters] = obtainClusters(image, options);
[image, clusters] = analyzeClusters(image, clusters, options);

end

