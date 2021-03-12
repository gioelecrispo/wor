function boolean = isEndPoint(image, point)

pointsMatrix = image.pointsMatrix;

if isnan(pointsMatrix(point(1), point(2), PointClassificationType.END_POINT))
    disp('asdsda')
end  

boolean = logical(pointsMatrix(point(1), point(2), PointClassificationType.END_POINT));
