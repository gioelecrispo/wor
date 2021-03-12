function [endPointFound, pxCounter, ePoint, unfoldedArray] = traceFollowing_untilEndPoint(image, clusters, options, starter, exitDirection)

logger = getLogger(options);

%%% INIZIALIZZO OUTPUT
ePoint = [];
unfoldedArray = [];
pxCounter = 1;

%%% PREPARAZIONE CICLO
% Inizializzo currPixel con lo starter.
% Computo la OPPOSITE DIRECTION, Per evitare di tornare nel cluster.
currPixel = starter;
oppositeDirection = computeOppositeDirection(exitDirection);

%%% CICLO - TRACE FOLLOWING
% INIZIALIZZO CONDIZIONI
% La condizione di uscita del while è l'aver incontrato un endPoint. Se ciò
% non succede, vuol dire che si è usciti per aver incontrato un cluster non
% risolto oppure un retracing point.
endPointFound = isEndPoint(image, currPixel); % image.toolMatrix(currPixel(1), currPixel(2)) == PointType.END_POINT;
retracingPointFound = isRetracingPoint(image, currPixel); % image.toolMatrix(currPixel(1), currPixel(2)) == PointType.RETRACING_POINT;
clusterFound = isBranchPoint(image, currPixel); %image.toolMatrix(currPixel(1), currPixel(2)) > PointType.TRACE_POINT;
retracingClusterFound = false;
if clusterFound 
    clusterIndex = getBelongingCluster(image, currPixel); %[~, clusterIndex] = checkClusterMembership(currPixel, oppositeDirection, clusters); 
    endPointFound = isa(clusters(clusterIndex).relationship, 'Unique');
end


while ~endPointFound && ~retracingPointFound && ~retracingClusterFound
    
    % Eseguo TRACE FOLLOWING
    [currPixel, direction, unfoldedPixels] = traceFollowing(image, clusters, options, currPixel, oppositeDirection);
    
    % Aggiorno UNFOLDED_ARRAY
    unfoldedArray = [unfoldedArray; unfoldedPixels];

    % Aggiorno info TRACE FOLLOWING
    currPixel = currPixel + direction;
    oppositeDirection = computeOppositeDirection(direction);
    
    % Aggiorno condizioni di uscita
    endPointFound = isEndPoint(image, currPixel); 
    retracingPointFound = isRetracingPoint(image, currPixel); 
    clusterFound = isBranchPoint(image, currPixel);
    if clusterFound
        clusterIndex = getBelongingCluster(image, currPixel);
        if clusters(clusterIndex).processed == false 
            break;
        elseif isa(clusters(clusterIndex).relationship, 'Unique')
            if isRetracingPoint(image, currPixel)
                retracingPointFound = true; 
            else
                endPointFound = true; 
            end
            break;
        end
    end
    
    
    % Aggiorno pxCounter
    pxCounter = pxCounter + 1;
    
    % CONTROLLO TIPO CLUSTER
    % Verifico che il cluster trovato sia non risolto. Se ciò accade,
    % bisogna uscire dalla funzione. Particolare attenzione va ai cluster
    % dispari di rango > 3.
    if clusterFound
        if isTheSameDirection(direction, Directions.NO_DIRECTION)
            break;
        end
    end
end

% Si è giunti in un END POINT o un RETRACING, si registra tale punto
if endPointFound == true || retracingPointFound == true
    ePoint = currPixel;
else
    unfoldedArray = [];
end


end



