function boolean = isFalseTracePoint(image, point)

pointsMatrix = image.pointsMatrix;

boolean = logical(pointsMatrix(point(1), point(2), PointClassificationType.FALSE_TRACE_POINT));
