function image = setAnchorBranchPoint(image, point, clusterIndex)

image.pointsMatrix(point(1),point(2),:) = [0 0 0 0 1 1 clusterIndex];

end