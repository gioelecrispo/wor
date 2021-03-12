function [image, clusters] = obtainClusters(image, options)
% The function analyzes the connected components in the PointMatrixbranch 
% matrix and extracts them in a structure called cc. The clusters are then 
% reorganized.
%pointsMatrix = image.pointsMatrix;

logger = getLogger(options);

branchPointsMatrix = getBranchPointsMatrix(image);

cc = bwconncomp(branchPointsMatrix);

clusters = [];
if cc.NumObjects ~= 0
    clusters(cc.NumObjects).pixels = [];
    for k = 1 : cc.NumObjects
        [xcc,ycc] = ind2sub(size(branchPointsMatrix), cc.PixelIdxList{k});
        clusters(k).pixels = [xcc, ycc]; 
        numPixels = length(xcc);
        for i = 1 : numPixels
            image = setBelongingCluster(image, [xcc(i),ycc(i)], k);
            %pointsMatrix(xcc(i),ycc(i), PointClassificationType.BELONGING_CLUSTER) = k;
        end
    end    
end

logger.info('Clusters number: %d', cc.NumObjects);

%image.pointsMatrix = pointsMatrix;