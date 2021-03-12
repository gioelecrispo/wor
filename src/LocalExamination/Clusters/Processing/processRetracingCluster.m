function [image, clusters] = processRetracingCluster(clusterIndex, image, clusters, options)

logger = getLogger(options);
logger.info('Processing retracing cluster: %d', clusterIndex);

%%% OTTENIMENTO INFORMAZIONI CLUSTER
pixels = clusters(clusterIndex).pixels;
falseTracePoints =  clusters(clusterIndex).falseTracePoints;
clusterPoints = [pixels; falseTracePoints];
anchorBP = clusters(clusterIndex).anchorBP;
exitDirections = clusters(clusterIndex).exitDirections;
clusterRank =  clusters(clusterIndex).clusterRank;
adiacency = clusters(clusterIndex).adiacency;
internalAngles = clusters(clusterIndex).internalAngles;
externalAngles = clusters(clusterIndex).externalAngles;


%%% OTTENIMENTO INFO RISOLUZIONE IMMAGINE
maxImageDimension = max(image.dimensions);

%%% CLUSTER CON RETRACING
% Se vi è un angolo che è più piccolo degli altri e gli altri due hanno
% un'ampiezza pressoché simile e il vertice opposto all'angolo più
% piccolo continua e termina in un endPoint, allora c'è un retracing su
% quel ramo.

%%%% 
%[~, externalAnglesDistances, internalAnglesDistances, dijkstraCurvatures] = computeExitBranchesContributions(clusterIndex, image, clusters);
combinations = clusters(clusterIndex).branchesCombinations;
externalAnglesDistances = clusters(clusterIndex).externalAnglesDistances;
internalAnglesDistances = clusters(clusterIndex).internalAnglesDistances;
dijkstraCurvatures = clusters(clusterIndex).dijkstraCurvatures;

allContributes = getAllContributes_Retracing(WeightedVote.T_PATTERN_RETR, externalAnglesDistances, internalAnglesDistances, 180-dijkstraCurvatures);
[retracingAnchorBP, retracingIndex] = findVertexOppositeToMinAngle(adiacency, allContributes, anchorBP);
if ~isnan(retracingIndex)  % Sono soddisfatti i criteri per il retracing
    % Vedo se su quel vertice ci sono endPoint
    exitDirection = exitDirections(retracingIndex,:);
    starter = retracingAnchorBP + exitDirection;
    [endPointFound, pxCount, ePoint, unfoldedArray] = traceFollowing_untilEndPoint(image, clusters, options, starter, exitDirection);
    if endPointFound == true && pxCount < (Thresholds.RETRACING_MAX_SEGMENT_LENGTH * maxImageDimension)/100
        isStraight = evaluateStraightness(unfoldedArray, Thresholds.NUM_POINTS_STRAIGHTNESS, Thresholds.CURVATURE_AROUNDNESS);
        if isStraight == true
            logger.debug('Cluster %d is a retracing.', clusterIndex);
            
            if ~isBranchPoint(image, ePoint)
                % it is a retracing point
                image = setRetracingPoint(image, ePoint);
            else
                % it is a cluster retracing point
                clusterRetracingIndex = getBelongingCluster(image, ePoint);
                clusters(clusterRetracingIndex).relationship.retracing = true;
                image = setClusterRetracingPoint(image, ePoint, clusterRetracingIndex);
            end
            
            anchorBPIndexes = 1:clusterRank;
            anchorBPIndexes(retracingIndex) = [];
            %%% ASSOCIAZIONE PATH      
            % CLUSTER CORRENTE
            numPaths = length(anchorBPIndexes);
            pairedIndexes = zeros(numPaths, 2);
            paths = cell(1, numPaths);
            for i = 1 : length(anchorBPIndexes)
                source = anchorBP(anchorBPIndexes(i),:);
                destination = retracingAnchorBP;
                [paths{i}, clusters] = retrievePathFromDijkstra(clusterIndex, clusters, source, destination);
                pairedIndexes(i,:) = [retracingIndex; anchorBPIndexes(i)];
            end
            clusters(clusterIndex).paths = paths;
            clusters(clusterIndex).relationship = Solo(pairedIndexes, paths);
            clusters(clusterIndex).processed = true;
            return;
        end
    end
else
    logger.debug('Cluster %d is not a retracing.', clusterIndex);
end


end