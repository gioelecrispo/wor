function [] = drawClusterPixels(clusterIndex, image, clusters, h)

if ~exist('h', 'var')
    h = figure('units','normalized','outerposition',[0 0 1 1]); imagesc(image.bw); colormap(gray);
end


hold on
pixels = clusters(clusterIndex).pixels;
[lengthPixels, ~] = size(pixels);
for i = 1 : lengthPixels
    text(pixels(i,2), pixels(i,1), num2str(i), 'Color', 'r')
end

falseTracePoints = clusters(clusterIndex).falseTracePoints;
[lengthFalseTracePoints, ~] = size(falseTracePoints);
for j = 1 : lengthFalseTracePoints
    text(falseTracePoints(j,2), falseTracePoints(j,1), num2str(j+i), 'Color', 'c')
end