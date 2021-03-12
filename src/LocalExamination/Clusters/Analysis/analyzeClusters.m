function [image, clusters] = analyzeClusters(image, clusters, options)

logger = getLogger(options);
logger.info('--> Analyzing clusters...')

%%% CLUSTERS INITIALIZATION
% The following lines are need to initialize all the fields of the clusters
% structure.
[~, lengthClusters] = size(clusters);
if lengthClusters > 0
    clusters(1).anchorBP = [];
    clusters(1).exitDirections = [];
    clusters(1).falseTracePoints = [];
    clusters(1).clusterRank = [];
    clusters(1).adiacency = [];
    clusters(1).internalAngles = [];
    clusters(1).internalAnglesFrom0 = [];
    clusters(1).externalAngles = [];
    clusters(1).branchesCombinations = []; 
    clusters(1).externalAnglesDistances = []; 
    clusters(1).internalAnglesDistances = []; 
    clusters(1).dijkstraCurvatures = []; 
    clusters(1).graph = [];
    clusters(1).relationship = [];
    clusters(1).processed = [];
    clusters(1).delete = [];
    
    %%% CLUSTERS ANALYSIS
    % The clusters is analyzed in its entirety and all its useful information
    % for its resolution are registered. This allows fast and effective
    % information access without recalculating them every time. All the
    % information is saved in the cluster structure.
    for clusterIndex = 1 : lengthClusters
        logger.debug('Analyzing cluster ID: %d', clusterIndex);
        [image, clusters] = computeClusterInfo(clusterIndex, image, clusters, options);
    end
    
end



end