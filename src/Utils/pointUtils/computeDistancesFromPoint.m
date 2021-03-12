function distancesFromPoint = computeDistancesFromPoint(point, pointsSet)

[lengthPointsSet, ~] = size(pointsSet);
distancesFromPoint = zeros(1, lengthPointsSet);
for i = 1 : lengthPointsSet
    distancesFromPoint(i) = pdist([point; pointsSet(i,:)], 'euclidean');
end

end