function boolean = isClusterPoint(image, point)

pointsMatrix = image.pointsMatrix;

isCluster = ~isnan(pointsMatrix(point(1), point(2), PointClassificationType.FALSE_TRACE_POINT:PointClassificationType.ANCHOR_BRANCH_POINT)); 
boolean = false;
if logical(sum(isCluster)) == true
    if (pointsMatrix(point(1), point(2), PointClassificationType.FALSE_TRACE_POINT) == 1) || ... 
            (pointsMatrix(point(1), point(2), PointClassificationType.BRANCH_POINT) == 1) || ...
            (pointsMatrix(point(1), point(2), PointClassificationType.ANCHOR_BRANCH_POINT) == 1)
        boolean = true;
    end
end
