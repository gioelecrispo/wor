function image = setTracePoint(image, point)

image.pointsMatrix(point(1),point(2),:) = [0 0 1 0 0 0 NaN];

end