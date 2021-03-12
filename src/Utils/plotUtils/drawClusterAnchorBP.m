function h = drawClusterAnchorBP(image, clusters, clusterIndex, h)

anchorBP = clusters(clusterIndex).anchorBP;


if ~exist('h', 'var')
    h = figure('units','normalized','outerposition',[0 0 1 1]); imagesc(image.bw); colormap(gray);
end

hold on
[lengthCluster, ~] = size(anchorBP);
for i = 1 : lengthCluster
    text(anchorBP(i,2), anchorBP(i,1), [num2str(i)], 'Color', 'r')
end