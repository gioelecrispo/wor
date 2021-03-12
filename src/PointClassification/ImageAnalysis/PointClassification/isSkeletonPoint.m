function boolean = isSkeletonPoint(image, point)

pointsMatrix = image.pointsMatrix;


isSkeleton = ~isnan(pointsMatrix(point(1), point(2), PointClassificationType.END_POINT:PointClassificationType.ANCHOR_BRANCH_POINT)); 

boolean = logical(sum(isSkeleton));
