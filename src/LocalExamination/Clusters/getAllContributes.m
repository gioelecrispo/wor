function allContributes = getAllContributes(WEIGHTS, externalAnglesDistances, internalAnglesDistances, dijkstraCurvatures)

WEIGHT_EXTERNAL = WEIGHTS(1);
WEIGHT_INTERNAL = WEIGHTS(2);
WEIGHT_DIJKSTRA = WEIGHTS(3); 

externalAnglesDistancesFrom180 = abs(externalAnglesDistances - 180) * WEIGHT_EXTERNAL;
internalAnglesDistancesFrom180 = abs(internalAnglesDistances - 180) * WEIGHT_INTERNAL;
dijkstraCurvatures = dijkstraCurvatures * WEIGHT_DIJKSTRA;

allContributes = externalAnglesDistancesFrom180 + internalAnglesDistancesFrom180 + dijkstraCurvatures;

end