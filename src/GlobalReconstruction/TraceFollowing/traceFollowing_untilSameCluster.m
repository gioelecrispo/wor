function [sameClusterFound, pxCounter, unfoldedArray] = traceFollowing_untilSameCluster(image, clusters, options, starter, exitDirection, clusterIndex)

logger = getLogger(options);

%% IMPORTANT. Used only for loops detection (alpha feature)

%%% INIZIALIZZO OUTPUT
pxCounter = 1;
unfoldedArray = [];

%%% PREPARAZIONE CICLO
% Inizializzo currPixel con lo starter.
% Computo la OPPOSITE DIRECTION, Per evitare di tornare nel cluster.
currPixel = starter;
oppositeDirection = computeOppositeDirection(exitDirection);


%%% CICLO - TRACE FOLLOWING
% INIZIALIZZO CONDIZIONI
% La condizione di uscita del while è l'aver incontrato lo stesso cluster. 
% Se ciò non succede, vuol dire che si è usciti per aver incontrato un 
% endPoint o un retracing point.
sameClusterFound = false;
endPointFound = image.toolMatrix(currPixel(1), currPixel(2)) == PointType.END_POINT || image.toolMatrix(currPixel(1), currPixel(2)) == PointType.CLUSTER_END_POINT;
retracingPointFound = image.toolMatrix(currPixel(1), currPixel(2)) == PointType.RETRACING_POINT;
    
while ~sameClusterFound && ~endPointFound && ~retracingPointFound
    
    % Aggiorno condizioni di uscita
    clusterFound = image.toolMatrix(currPixel(1), currPixel(2)) > PointType.TRACE_POINT;
    endPointFound = image.toolMatrix(currPixel(1), currPixel(2)) == PointType.END_POINT || image.toolMatrix(currPixel(1), currPixel(2)) == PointType.CLUSTER_END_POINT;
    retracingPointFound = image.toolMatrix(currPixel(1), currPixel(2)) == PointType.RETRACING_POINT;
    
    if clusterFound 
        [~, clusterFoundIndex] = checkClusterMembership(currPixel, clusters);
        if clusterFoundIndex == clusterIndex
            sameClusterFound = true;
            break;
        else
            relationship = clusters(clusterFoundIndex).relationship;
            if isa(relationship, 'Solo')
                retracingIndex = relationship.retracingIndex;
                retracingAnchorBP = clusters(clusterFoundIndex).anchorBP(retracingIndex,:);
                if isTheSamePoint(currPixel, retracingAnchorBP)
                    break;
                end
            end
        end
    end

    % Eseguo TRACE FOLLOWING
    [currPixel, direction, unfoldedPixels] = traceFollowing(image, clusters, currPixel, oppositeDirection);
    
    % Aggiorno UNFOLDED ARRAY
    unfoldedArray = [unfoldedArray; unfoldedPixels];

    % Aggiorno info TRACE FOLLOWING
    currPixel = currPixel + direction;
    oppositeDirection = computeOppositeDirection(direction);
    
    % Aggiorno pxCounter
    pxCounter = pxCounter + 1;
    
end

if sameClusterFound == false
    unfoldedArray = [];
end

