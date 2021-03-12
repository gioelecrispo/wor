function [] = drawClusterID(image, clusters)



f = figure('units','normalized','outerposition',[0 0 1 1], 'KeyPressFcn', {@searchClusterID, clusters}, 'KeyReleaseFcn', @resetFcnState),
imagesc(image.bw), 
colormap(gray),
hold on

COLOR_CLUSTER_ID            = [1 0 0];
COLOR_DELETED_CLUSTER_ID    = [0.4 0.4 0.4];

[~, lengthClusters] = size(clusters);
for clusterIndex = 1 : lengthClusters
    pixels = clusters(clusterIndex).pixels;
    falseTracePoints = clusters(clusterIndex).falseTracePoints;
    clusterPoints = [pixels; falseTracePoints];
    massCenter = [mean(clusterPoints(:,1)), mean(clusterPoints(:,2))];
    delete = clusters(clusterIndex).delete;
    if delete    
        color = COLOR_DELETED_CLUSTER_ID;
    else
        color = COLOR_CLUSTER_ID;
        % OTTIENI RETTANGOLI CHE ISCRIVONO IL CLUSTER
        minX = min(clusterPoints(:,1));
        maxX = max(clusterPoints(:,1));
        minY = min(clusterPoints(:,2));
        maxY = max(clusterPoints(:,2));
        rect = [minY-0.5, minX-0.5, (maxY-minY)+1, (maxX-minX)+1];
        rectangle('Position', rect, 'Curvature',[0,0], 'LineWidth', 1, 'LineStyle', '-', 'EdgeColor', color);
    end
    text(massCenter(1,2), massCenter(1,1), ['C' num2str(clusterIndex)], 'Color', color);
end
end


function searchClusterID(src, event, clusters)

    clusterID = inputdlg('Insert desired cluster ID: ', 'Cluster ID Finder');
    clusterID = str2num(clusterID{1});
    pixels = clusters(clusterID).pixels;
    falseTracePoints = clusters(clusterID).falseTracePoints;
    clusterPoints = [pixels; falseTracePoints];
    minX = min(clusterPoints(:,1)) - 5;
    maxX = max(clusterPoints(:,1)) + 5;
    minY = min(clusterPoints(:,2)) - 5;
    maxY = max(clusterPoints(:,2)) + 5;
    axis([minY, maxY, minX, maxX]);
    
end

function resetFcnState(src, event)

end