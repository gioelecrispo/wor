function [clusterFound, clusterFoundIndex, pxCounter, cPoint, anchorBPIndexFound, unfoldedArray] = traceFollowing_untilNextCluster(image, clusters, options, starter, exitDirection)

logger = getLogger(options);

%%% INIZIALIZZO OUTPUT
cPoint = []; 
clusterFoundIndex = [];
anchorBPIndexFound = [];
unfoldedArray = [];
pxCounter = 1;

%%% PREPARAZIONE CICLO
% Inizializzo currPixel con lo starter.
% Computo la OPPOSITE DIRECTION, Per evitare di tornare nel cluster.
currPixel = starter;
oppositeDirection = computeOppositeDirection(exitDirection);


%%% CICLO - TRACE FOLLOWING
% INIZIALIZZO CONDIZIONI
% La condizione di uscita del while è l'aver incontrato un cluster. Se ciò 
% non succede, vuol dire che si è usciti per aver incontrato un endPoint o 
% un retracing point.
clusterFound = isClusterPoint(image, currPixel); %image.toolMatrix(currPixel(1), currPixel(2)) > PointType.TRACE_POINT;
endPointFound = isEndPoint(image, currPixel); %image.toolMatrix(currPixel(1), currPixel(2)) == PointType.END_POINT || image.toolMatrix(currPixel(1), currPixel(2)) == PointType.CLUSTER_END_POINT;
retracingPointFound = isRetracingPoint(image, currPixel); %image.toolMatrix(currPixel(1), currPixel(2)) == PointType.RETRACING_POINT;
    
while ~clusterFound && ~endPointFound && ~retracingPointFound

    % Eseguo TRACE FOLLOWING
    [currPixel, direction, unfoldedPixels] = traceFollowing(image, clusters, options, currPixel, oppositeDirection);
    
    % Aggiorno UNFOLDED_ARRAY
    unfoldedArray = [unfoldedArray; unfoldedPixels];
    
    % Aggiorno info TRACE FOLLOWING
    currPixel = currPixel + direction;
    oppositeDirection = computeOppositeDirection(direction);
    
    % Aggiorno condizioni di uscita
    clusterFound = isClusterPoint(image, currPixel); %image.toolMatrix(currPixel(1), currPixel(2)) > PointType.TRACE_POINT;
    endPointFound = isEndPoint(image, currPixel); %image.toolMatrix(currPixel(1), currPixel(2)) == PointType.END_POINT || image.toolMatrix(currPixel(1), currPixel(2)) == PointType.CLUSTER_END_POINT;
    retracingPointFound = isRetracingPoint(image, currPixel); %image.toolMatrix(currPixel(1), currPixel(2)) == PointType.RETRACING_POINT;
   
    % Aggiorno pxCounter
    pxCounter = pxCounter + 1;
    
end

%%% AGGIORNO OUTPUT
if clusterFound == true
    clusterFoundIndex = getBelongingCluster(image, currPixel); %[~, clusterFoundIndex] = checkClusterMembership(currPixel, oppositeDirection, clusters);
    cPoint = currPixel; 
    anchorBPFound = clusters(clusterFoundIndex).anchorBP;
    exitDirectionsFound = clusters(clusterFoundIndex).exitDirections;
    [~, anchorBPIndexFound] = belongsToCluster(cPoint, oppositeDirection, anchorBPFound, exitDirectionsFound);
end


