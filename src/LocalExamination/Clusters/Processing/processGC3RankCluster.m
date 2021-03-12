function [image, clusters] = processGC3RankCluster(clusterIndex, image, clusters, options)

logger = getLogger(options);
logger.info('Processing remaining 3-rank cluster: %d', clusterIndex);


[image, clusters] = createParenthood(clusterIndex, image, clusters, options);


%%% RISOLVO GIA' I CLUSTER FIGLI
[~, lengthClusters] = size(clusters);
clusterIndex_c1 = lengthClusters - 1;
clusterIndex_c2 = lengthClusters;
[image, clusters] = process1RankCluster(clusterIndex_c1, image, clusters, options);
[image, clusters] = processEvenRankCluster(clusterIndex_c2, image, clusters, options);



















end




% function vertexToRemove = computerVertexToRemove(adiacency, angles)
%     [lengthAdiacency, ~] = size(adiacency);
%     anglesDistances = zeros(lengthAdiacency, 1);
%     for k = 1 : lengthAdiacency
%         i = adiacency(k,1);
%         j = adiacency(k,2);
%         anglesDistances(k) = angdiffd(angles(i), angles(j));
%     end
%     anglesDistances = abs(anglesDistances - 180);
%     [~, minIndex] = min(anglesDistances);
%     v(1) = adiacency(minIndex,1);
%     v(2) = adiacency(minIndex,2);
%     vertexToRemove = 1:lengthAdiacency;
%     vertexToRemove(v) = [];
% end