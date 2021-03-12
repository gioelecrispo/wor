function [isClusterRank3, clusterFoundIndex, pxCounter, cPoint, anchorBPIndex, unfoldedArray] = traceFollowing_untilNextClusterRank3(image, clusters, options, starter, exitDirection)


logger = getLogger(options);

%%% INIZIALIZZO OUTPUT
cPoint = [];
anchorBPIndex = [];
clusterFoundIndex = [];
unfoldedArray = [];
pxCounter = 1;

%%% PREPARAZIONE CICLO
% Inizializzo currPixel con lo starter.
% Computo la OPPOSITE DIRECTION, Per evitare di tornare nel cluster.
currPixel = starter;
oppositeDirection = computeOppositeDirection(exitDirection);

%%% CICLO - TRACE FOLLOWING
% INIZIALIZZO CONDIZIONI
% La condizione di uscita del while è l'aver incontrato un cluster di rango
% 3 non risolto. Se ciò non succede, vuol dire che si è usciti per aver
% incontrato un endPoint o un retracing point.
clusterFound = isBranchPoint(image, currPixel); %image.toolMatrix(currPixel(1), currPixel(2)) > PointType.TRACE_POINT;
endPointFound = isEndPoint(image, currPixel); %image.toolMatrix(currPixel(1), currPixel(2)) == PointType.END_POINT || image.toolMatrix(currPixel(1), currPixel(2)) == PointType.CLUSTER_END_POINT;
retracingPointFound = isBranchPoint(image, currPixel); %image.toolMatrix(currPixel(1), currPixel(2)) == PointType.RETRACING_POINT;
isClusterRank3 = false;

while ~isClusterRank3 && ~endPointFound && ~retracingPointFound
    
    % Eseguo TRACE FOLLOWING
    [currPixel, direction, unfoldedPixels] = traceFollowing(image, clusters, options, currPixel, oppositeDirection);    

    % Aggiorno UNFOLDED_ARRAY
    unfoldedArray = [unfoldedArray; unfoldedPixels];
    
    % Aggiorno info TRACE FOLLOWING
    currPixel = currPixel + direction;
    oppositeDirection = computeOppositeDirection(direction);
    
    % Aggiorno condizioni di uscita
    clusterFound = isBranchPoint(image, currPixel); %image.toolMatrix(currPixel(1), currPixel(2)) > PointType.TRACE_POINT;
    endPointFound = isEndPoint(image, currPixel); %image.toolMatrix(currPixel(1), currPixel(2)) == PointType.END_POINT || image.toolMatrix(currPixel(1), currPixel(2)) == PointType.CLUSTER_END_POINT;
    retracingPointFound = isRetracingPoint(image, currPixel); %image.toolMatrix(currPixel(1), currPixel(2)) == PointType.RETRACING_POINT;
    
    % Aggiorno pxCounter
    [lengthUnfoldedPixels, ~] = size(unfoldedPixels);
    pxCounter = pxCounter + lengthUnfoldedPixels;
    
    % CONTROLLO TIPO CLUSTER
    % Verifico che il cluster trovato sia di rango 3 e non risolto. Qualora
    % si finisca in un cluster di rango dispari > 3, su un percorso non
    % risolto, si deve vedere se c'è la possibilità di puntare al
    % figlio (di rango 3) e verificare che esso sia non risolto.
    if clusterFound
        %[~, clusterFoundIndex] = checkClusterMembership(currPixel, oppositeDirection, clusters);
        clusterFoundIndex = getBelongingCluster(image, currPixel);
        clusterRankFound = clusters(clusterFoundIndex).clusterRank;
        processedFound = clusters(clusterFoundIndex).processed;
        if ~processedFound
            anchorBPFound = clusters(clusterFoundIndex).anchorBP;
            exitDirectionsFound = clusters(clusterFoundIndex).exitDirections;
            [~, anchorBPIndexFound] = belongsToCluster(currPixel, oppositeDirection, anchorBPFound, exitDirectionsFound);
            if clusterRankFound == 3
                isClusterRank3 = true;
                cPoint = currPixel;
                anchorBPIndex = anchorBPIndexFound;
            elseif isOdd(clusterRankFound) && clusterRankFound > 3
                % è un cluster dispari di rango maggiore di 3
                % Bisogna controllare se si è in un anchorBP che appartiene
                % al figlio.
                % Se non appartiene al cluster figlio e non si è su un
                % percorso già risolto, allora si deve uscire dall funzione
                % come se fossimo giunti ad un cluster irrisolto.
                if clusters(clusterFoundIndex).processed == true
                    [childID, child_index] = clusters(clusterFoundIndex).relationship.retrieveChildIndexes(anchorBPIndexFound);
                    child = clusters(childID);
                    child_clusterRank = child.clusterRank;
                    child_resolved = child.resolved;
                    if child_clusterRank == 3 && ~child_resolved
                        clusterFoundIndex = childID;
                        isClusterRank3 = true;
                        cPoint = currPixel;
                        anchorBPIndex = child_index;
                    end
                end
            end
        end
        %%% CONDIZIONE DI USCITA
        %   direction == Directions.NO_DIRECTION
        % Vuol dire che si è finiti in una situazione in cui il path di
        % attraversamento cluster non è stato definito e dunque la funzione
        % di trace_following ha resistuito una direzione NULLA.
        if isTheSameDirection(direction, Directions.NO_DIRECTION)
            break;
        end
    end
    
end


