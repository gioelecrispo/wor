function distances = computeEuclideanDistanceBetweenPoints(points)

[lengthPoints, ~] = size(points);

distances = zeros(lengthPoints);

for i = 1 : lengthPoints
    for j = i + 1 : lengthPoints
        distances(i,j) = pdist([points(i,:); points(j,:)], 'euclidean');
    end
end


end