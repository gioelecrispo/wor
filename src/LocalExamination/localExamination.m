function [image, clusters] = localExamination(image, clusters, options)

logger = getLogger(options);
logger.info('** Local Examination **');

% - Skeleton correction 
[image, clusters] = correctSkeletonErrors(image, clusters, options);

% - Cluster processing
[image, clusters] = processClusters(image, clusters, options);

end