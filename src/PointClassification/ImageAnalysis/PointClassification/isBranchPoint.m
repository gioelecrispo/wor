function boolean = isBranchPoint(image, point)

pointsMatrix = image.pointsMatrix;

boolean = logical(pointsMatrix(point(1), point(2), PointClassificationType.BRANCH_POINT));
