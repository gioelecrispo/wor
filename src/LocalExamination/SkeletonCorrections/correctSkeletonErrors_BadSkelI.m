function [image, clusters, modified] = correctSkeletonErrors_BadSkelI(clusterIndex, image, clusters)

modified = false;

anchorBP = clusters(clusterIndex).anchorBP;
exitDirections = clusters(clusterIndex).exitDirections;
clusterRank = clusters(clusterIndex).clusterRank;
adiacency = clusters(clusterIndex).adiacency;
internalAngles = clusters(clusterIndex).internalAngles;
externalAngles = clusters(clusterIndex).externalAngles;

[maxInternalAngle, maxInternalAngleIndex] = max(internalAngles); 

% Se l'angolo maggiore soddisfa il requisito imposto dalla soglia, allora
% si cerca il vertice opposto all'angolo e si vede se è connesso ad un
% altro cluster di rango 3.
if maxInternalAngle*100/360 > Thresholds.BAD_SKEL_I_MIN_ANGLE_WIDENESS
    i = adiacency(maxInternalAngleIndex,1);
    j = adiacency(maxInternalAngleIndex,2);
    verteces = [adiacency(i,:), adiacency(j,:)];
    % Find the unique values
    uniqueVals = unique(verteces);
    % Count the number of instances of each of the unique vals
    valCount = hist(verteces, uniqueVals);
    [~, anchorBPIndex] = max(valCount);

    bp = anchorBP(anchorBPIndex,:);
    exitDirection = exitDirections(anchorBPIndex,:);
    starter = bp + exitDirection;
    [clusterFound, distance, ~, nearestAnchorBPIndex, clusterFoundIndex] = traceFollowing_untilNextCluster(image, clusters, starter, exitDirection);
    
    if clusterFound == true
        nearestClusterRank = clusters(clusterFoundIndex).clusterRank;
        
        if nearestClusterRank == 3
            nearestAnchorBP = clusters(clusterFoundIndex).anchorBP;
            %nearestDirectionsOutsideCluster = clusters(clusterFoundIndex).directionsOutsideCluster;
            nearestInternalAngles = clusters(clusterFoundIndex).internalAngles;
            nearestExternalAngles = clusters(clusterFoundIndex).externalAngles; 

            % Verifico che l'angolo opposto all'anchorBP del cluster appena 
            % trovato (cioè connesso con il cluster precedente) rispetti le
            % condizioni imposte dalla soglia per essere classificato come
            % BAD_SKEL_I pattern.
            nearestVerteces = 1:nearestClusterRank;
            nearestVerteces(nearestAnchorBPIndex) = [];   
            [~, oppositeAngleIndex] = belongsTo(nearestVerteces, adiacency);
            oppositeAngle = nearestInternalAngles(oppositeAngleIndex);
            if oppositeAngle*100/360 > Thresholds.BAD_SKEL_I_MIN_ANGLE_WIDENESS
                segmentSlang = angdiffd(externalAngles(anchorBPIndex), nearestExternalAngles(nearestAnchorBPIndex));
                if segmentSlang*100/360 > Thresholds.BAD_SKEL_I_MIN_SEGMENT_SLANG
                    if distance < Thresholds.BAD_SKEL_I_MAX_SEGMENT_LENGTH 
                        modified = true;
                        currPixel = starter;
                        lastPointToDelete = nearestAnchorBP(nearestAnchorBPIndex,:); % + nearestDirectionsOutsideCluster(nearestAnchorBPIndex,:);
                        oppositeDirection = computeOppositeDirection(exitDirection);
                        while ~isTheSamePoint(currPixel, lastPointToDelete)
                            [currPixel, direction, ~] = traceFollowing(image, clusters, currPixel, oppositeDirection);
                            image.bw(currPixel(1), currPixel(2)) = PointType.WHITE;
                            %image = setNoSkeletonPoint(image, currPixel);
                            currPixel = currPixel + direction;
                        end
                    end
                end
            end
        end
    end
end


