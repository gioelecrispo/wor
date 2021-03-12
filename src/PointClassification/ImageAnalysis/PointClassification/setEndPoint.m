function image = setEndPoint(image, point)

image.pointsMatrix(point(1),point(2),:) = [1 0 0 0 0 0 NaN];

end