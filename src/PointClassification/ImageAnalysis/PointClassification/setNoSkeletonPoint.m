function image = setNoSkeletonPoint(image, point)

image.pointsMatrix(point(1),point(2),:) = [NaN NaN NaN NaN NaN NaN NaN];

end