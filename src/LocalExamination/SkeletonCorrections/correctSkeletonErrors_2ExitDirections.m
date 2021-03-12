function [image, clusters] = correctSkeletonErrors_2ExitDirections(clusterIndex, image, clusters, options)

logger = getLogger(options);
logger.info('Correcting SkeletonErrors: 2ExitDirections for cluster: %d', clusterIndex);

pixels = clusters(clusterIndex).pixels;
falseTracePoints = clusters(clusterIndex).falseTracePoints;
clusterPoints = [pixels; falseTracePoints];
anchorBP = clusters(clusterIndex).anchorBP;

if ~isempty(anchorBP)
    dijkstraPoints = anchorBP;
else
    % CLUSTER RANK 0
    clusterPointsDistances = computeEuclideanDistanceBetweenPoints(clusterPoints);
    [~, ind] = max(clusterPointsDistances(:));
    [farest1, farest2] = ind2sub(size(clusterPointsDistances), ind);
    point1 = clusterPoints(farest1,:);
    point2 = clusterPoints(farest2,:);
    %image.toolMatrix(point1(1), point1(2)) = PointType.END_POINT;
    %image.toolMatrix(point2(1), point2(2)) = PointType.END_POINT;
    image = setEndPoint(image, point1);
    image = setEndPoint(image, point2);
    dijkstraPoints = [point1; point2];
end

[~, rute] = dijkstra(clusters(clusterIndex).graph);
clusterStartIndex = findPositionInsideCluster(dijkstraPoints(1,:), clusterPoints);
clusterEndIndex = findPositionInsideCluster(dijkstraPoints(2,:), clusterPoints);
if iscell(rute)
    path = rute{clusterStartIndex, clusterEndIndex};
else
    path =  rute(clusterStartIndex, clusterEndIndex);
end
    
% Cerco nell'insieme dei punti del cluster quali sono quelli
% selezionati da dijkstra
[lenghtCluster, ~] = size(clusterPoints);
for i = 1 : lenghtCluster
    thereis = false;
    clusterPoint = clusterPoints(i,:);
    for j = 1 : length(path)
        if i == path(j)
            thereis = true;
            break;
        end
    end
    % Se il punto non è contenuto nel percorso va cancellato
    % dall'immagine originale
    if thereis == false
        image.bw(clusterPoint(1,1), clusterPoint(1,2)) = PointType.WHITE;
        %image = setNoSkeletonPoint(image, clusterPoint(1,:));
    end
end
% Ora che è stato definito il percorso minimo per il cluster di rango 2,
% essendo il percorso 8-connesso, il cluster non ha senso di esistere
clusters(clusterIndex).processed = true;
clusters(clusterIndex).delete = true;



end





