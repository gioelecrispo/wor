function [pxDistances, nearEndPoints] = findNearestEndPoints(clusterIndex, image, clusters, options)

%%% OTTENIMENTO INFO CLUSTER 
anchorBP = clusters(clusterIndex).anchorBP;
exitDirections = clusters(clusterIndex).exitDirections;
clusterRank = clusters(clusterIndex).clusterRank;

%%% INIZIALIZZAZIONE OUTPUT
pxDistances = zeros(clusterRank, 1);
nearEndPoints = zeros(clusterRank, 2);

%%% ESPLORAZIONE RAMI D'USCITA
% Su ogni ramo cerco un endPoint, attraversando i cluster quando possibile
% (cioè se sono stati risolti già).
for i = 1 : clusterRank
    exitDirection = exitDirections(i,:);
    starter = anchorBP(i,:) + exitDirection;
    [endPointFound, pxCounter, ePoint] = traceFollowing_untilEndPoint(image, clusters, options, starter, exitDirection);
    if endPointFound == true
        pxDistances(i) = pxCounter;
        nearEndPoints(i,:) = ePoint;
    else
        pxDistances(i) = NaN;
        nearEndPoints(i,:) = [NaN NaN];
    end
end


end