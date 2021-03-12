function endPoints = getImageEndPoints(image, clusters)

% [endX, endY] = find(image.toolMatrix == PointType.END_POINT);
% endPoints = [endX, endY];
% 
% for clusterIndex = 1 : length(clusters)
%     if isa(clusters(clusterIndex).relationship, 'Unique') && clusters(clusterIndex).relationship.retracing == false
%         endPoints = [endPoints; clusters(clusterIndex).anchorBP];
%     end
% end

endPoints = getEndPoints(image);

end