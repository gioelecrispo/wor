function [image, clusters] = computeGraph(clusterIndex, image, clusters, options)
% This function creates a graph (more properly an array of adjacency), so 
% that it can be used as dijkstra input.

logger = getLogger(options);

%%% Getting cluster information
pixels = clusters(clusterIndex).pixels;
falseTracePoints = clusters(clusterIndex).falseTracePoints;
clusterPoints = [pixels; falseTracePoints];

[lenghtClusterPoints, ~] = size(clusterPoints);
G = zeros(lenghtClusterPoints);

for i = 1 : lenghtClusterPoints
    currPixel = clusterPoints(i,:);
    for j = 1 : lenghtClusterPoints
        if ~isTheSamePoint(currPixel, clusterPoints(j,:))
            distance = abs(currPixel - clusterPoints(j,:));
            if (sum(distance <= [1  1])) == 2
                if (sum(distance) <= 1)
                    G(i,j) = 2;
                else
                    G(i,j) = 3;
                end
            end
        end
    end
end

logger.debug('Adjacency matrix computed.');
clusters(clusterIndex).graph = G;

end



