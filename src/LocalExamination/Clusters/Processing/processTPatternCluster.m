function [image, clusters] = processTPatternCluster(clusterIndex, image, clusters, options)

logger = getLogger(options);
logger.info('Processing T-Pattern cluster: %d', clusterIndex);

%%% OTTENIMENTO INFORMAZIONI CLUSTER
pixels = clusters(clusterIndex).pixels;
anchorBP = clusters(clusterIndex).anchorBP;
exitDirections = clusters(clusterIndex).exitDirections;
clusterRank =  clusters(clusterIndex).clusterRank;
adiacency = clusters(clusterIndex).adiacency;
internalAngles = clusters(clusterIndex).internalAngles;
internalAnglesFrom0 = clusters(clusterIndex).internalAnglesFrom0;
externalAngles = clusters(clusterIndex).externalAngles;



%%% GESTIONE T PATTERN
% Si controlla se il cluster di rango 3 in esame può essere considerato un
% T-PATTERN. Per ricadere in questa categoria il cluster deve soddisfare le
% seguenti condizioni:
% 1. un angolo interno compreso tra 180 - thresh e 180 + thresh, cioè:
%                  180 - THRESH < angInt < 180 + THRESH;
% 2. una coppia di angoli esterni forma un angolo molto vicino a 180, cioè
%    definito (exitDir_1 - exitDir_2) = angExt, deve essere:
%                  180 - THRESH < angExt < 180 + THRESH;
% 3. l'angolo interno angInt e la coppia di angoli esterni coppiaAngExt
%    devono essere definiti sugli stessi vertici (vedi figura);
% 4. il cluster non deve essere a meno di NUM_PIXELS pixel da un altro
%    cluster di rango 3 (con il quale potrebbe accoppiarsi), e da un
%    END_POINT (tramite il quale potrebbe fare un retracing).
%
%    ANGOLI INTERNI                                 ANGOLI ESTERNI
%
%          180°
%  1 ______________ 3        1,2,3       180° <-- 1 ______________ 3 --> 0°
%           |              indicano                        |
%      90°  |  90°         i vertici                       |
%           |                                      |       |
%            2                                     V  270°   2
%
% Negli angoli interni vi è un angolo che forma 180° e insiste sui vertici
% 1 e 3; allo stesso modo la coppia di angoli esterni 1 e 3 forma un angolo
% pari a 180°; in questo caso sono verificate le condizioni 1. 2. e 3.,
% essendo la coppia di vertici la stessa sia per gli angoli interni che
% esterni

%%% EXTERNAL ANGLES
% Calcolo differenza coppie angoli esterni e indici su cui insiste
%%%% 
externalAnglesDistances = clusters(clusterIndex).externalAnglesDistances;
internalAnglesDistances = clusters(clusterIndex).internalAnglesDistances;
dijkstraCurvatures = clusters(clusterIndex).dijkstraCurvatures;
allContributes = getAllContributes(WeightedVote.T_PATTERN_RETR, externalAnglesDistances, internalAnglesDistances, dijkstraCurvatures);
[minValue, minIndex] = min(allContributes);


% externalAnglesDistancesFrom180 = abs(externalAnglesDistances-180);
% [~, minExtIndex] = min(externalAnglesDistancesFrom180);
% angExt = externalAnglesDistances(minExtIndex);
% extIndexes = combinations(minExtIndex,:);
% 
% %%% INTERNAL ANGLES
% % Calcolo angoli interni e indici su cui insiste
% internalAnglesDistancesFrom180 = angdiffd(internalAngles, [180 180 180]);
% [~, minIntIndex] = min(internalAnglesDistancesFrom180);
% angInt = internalAngles(minIntIndex);
% intIndexes = adiacency(minIntIndex,:);

%%% CONTROLLO CONDIZIONI 1. 2. E 3.
% if (angInt > 180*(1 - Thresholds.T_PATTERN_DELTA_MAX_ANGLE) && angInt < 180*(1 + Thresholds.T_PATTERN_DELTA_MAX_ANGLE)) && ...
%         (angExt > 180*(1 - Thresholds.T_PATTERN_DELTA_MAX_ANGLE) && angExt < 180*(1 + Thresholds.T_PATTERN_DELTA_MAX_ANGLE)) && ...
%         (isTheSameCombination(extIndexes, intIndexes))
    
if minValue < Thresholds.T_PATTERN_DELTA_MAX_ANGLE/100*360

    %%% CALCOLO DISTANZE DA ALTRI CLUSTER DI RANGO 3 E DA END POINTS
    [endPointNearness, ~] = findNearestEndPoints(clusterIndex, image, clusters, options);
    minEndPoinNearness = min(endPointNearness);
    [~, ~, clusterNearness, ~, ~] = findNearestClusters(clusterIndex, image, clusters, options);
    minClusterNearness = min(clusterNearness);
    if isnan(minEndPoinNearness) 
        minEndPoinNearness = Thresholds.T_PATTERN_MIN_CLUSTER_ENDPOINT_NEARNESS + 1;
    end
    if isnan(minClusterNearness)
        minClusterNearness = Thresholds.T_PATTERN_MIN_CLUSTER_ENDPOINT_NEARNESS + 1;
    end
    
    
    
    otherContributesIndexes = 1:clusterRank;
    otherContributesIndexes(minIndex) = [];
    otherContributes = allContributes(otherContributesIndexes);
    
    %if otherAngles(1)*100/360 > Thresholds.T_PATTERN_OTHER_ANGLE_WIDENESS && otherAngles(2)*100/360 > Thresholds.T_PATTERN_OTHER_ANGLE_WIDENESS ...
    if otherContributes(1)*100/360 > Thresholds.T_PATTERN_OTHER_ANGLE_WIDENESS && otherContributes(2)*100/360 > Thresholds.T_PATTERN_OTHER_ANGLE_WIDENESS ...
            && minClusterNearness > Thresholds.T_PATTERN_MIN_CLUSTER_ENDPOINT_NEARNESS ...
            && minEndPoinNearness > Thresholds.T_PATTERN_MIN_CLUSTER_ENDPOINT_NEARNESS
        logger.debug('The cluster %d is T-pattern.', clusterIndex);
        
        
        [image, clusters] = createParenthood(clusterIndex, image, clusters, options);
        
        %%% RISOLVO GIA' I CLUSTER FIGLI
        [~, lengthClusters] = size(clusters);
        clusterIndex_c1 = lengthClusters - 1;
        clusterIndex_c2 = lengthClusters;
        [image, clusters] = process1RankCluster(clusterIndex_c1, image, clusters, options);
        [image, clusters] = processEvenRankCluster(clusterIndex_c2, image, clusters, options);
        return;
    end
end




end