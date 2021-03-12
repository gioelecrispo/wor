function allContributes = getAllContributes_Retracing(WEIGHTS, externalAnglesDistances, internalAnglesDistances, dijkstraCurvatures)

WEIGHT_EXTERNAL = WEIGHTS(1);
WEIGHT_INTERNAL = WEIGHTS(2);
WEIGHT_DIJKSTRA = WEIGHTS(3); 

externalAnglesDistances = externalAnglesDistances * WEIGHT_EXTERNAL;
internalAnglesDistances = internalAnglesDistances * WEIGHT_INTERNAL;
dijkstraCurvatures = (180 - dijkstraCurvatures) * WEIGHT_DIJKSTRA;

allContributes = externalAnglesDistances + internalAnglesDistances + dijkstraCurvatures;

end