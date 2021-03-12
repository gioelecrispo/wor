function boolean = isAnchorBranchPoint(image, point)

pointsMatrix = image.pointsMatrix;

boolean = logical(pointsMatrix(point(1), point(2), PointClassificationType.ANCHOR_BRANCH_POINT));
