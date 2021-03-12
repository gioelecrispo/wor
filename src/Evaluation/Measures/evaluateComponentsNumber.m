function numComponents = evaluateComponentsNumber(image, options, online8conn)

logger = getLogger(options);

startingPoints = getOnlineStartingPoints(online8conn);
[lengthStartingPoints, ~] = size(startingPoints);
numComponentsReal = lengthStartingPoints;

[lengthEndPoints, ~] = size(getEndPoints(image)); % [lengthEndPoints, ~] = size(image.endPoints.points);
numComponentsEstimated = floor(lengthEndPoints/2);

numComponents = [numComponentsReal, numComponentsEstimated];

end