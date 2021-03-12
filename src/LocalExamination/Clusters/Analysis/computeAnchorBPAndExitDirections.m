function [image, clusters] = computeAnchorBPAndExitDirections(clusterIndex, image, clusters, options)
% Found the cluster to which it belongs, we need to analyze it.
% Then we analyze the dimensions and find the possible directions e
% cluster anchor points. The anchor points are the points from
% which can be exited from the cluster (via the possible directions)

logger = getLogger(options);

pixels = clusters(clusterIndex).pixels;
exitDirections = [];
anchorBranchPoints = [];
[clusterLength, ~] = size(pixels);
for i = 1 : clusterLength
    currBPPixel = pixels(i,:);
    possibleDirections = analyzeNeighbors(currBPPixel, image);
    [directionsLength, ~] = size(possibleDirections);
    for j = 1 : directionsLength
        % check if moving in that direction defines a pixel beloginging 
        % to the same cluster
        currTracePoint = currBPPixel + possibleDirections(j,:);
        [contained, ~] = belongsTo(currTracePoint, pixels, true);
        if contained == false
            exitDirections = [exitDirections; possibleDirections(j,:)];
            anchorBranchPoints = [anchorBranchPoints; currBPPixel];
        end
    end
end




%%% CONTROLLO IL NUMERO DI TRACE POINT/END POINT DI USCITA
% Un ANCHOR BP è per definizione un punto del cluster connesso ad un TRACE
% POINT oppure ad un END POINT.
% Per questo motivo il rango del cluster viene definito come il numero di
% ANCHOR POINT.
% A volte però può capitare, per una cattiva scheletonizzazione che il
% numero di TRACE POINT/END POINT di uscita dal cluster sia diverso dal
% rango del cluster.
% Analizzando gli END POINT/TRACE POINT di uscita notiamo che:
%  - END POINT (1 vicino):
%       - connesso solo ad un cluster point.
%  - TRACE POINT (2 vicini):
%       - connesso ad un CLUSTER POINT e ad un altro TRACE POINT;
%       - connesso ad un CLUSTER POINT e ad un CLUSTER POINT di un altro
%         cluster;
%       - connesso a due CLUSTER POINT dello stesso cluster.
% Quest'ultimo caso è quello problematico: lo definiamo per semplicità
% FALSE TRACE POINT e va trattato alla stregua di un CLUSTER POINT.
%
% !!! Potrebbe verificarsi che un TRACE POINT incorra in altri due casi
% d'interesse e cioè che esso sia:
%       - connesso ad un CLUSTER POINT e ad un FALSE TRACE POINT;
%       - connesso a due FALSE TRACE POINT.
% Anche in quest'ultimi due casi il TRACE POINT va tramutato in FALSE TRACE
% POINT; questo è importante perché, per definizione, un FALSE TRACE POINT
% va considerato come un CLUSTER POINT, quindi è un TRACE POINT confinante
% con 2 CLUSTER POINTS.
%
% ESEMPI:
% Tenendo conto che:
%   o   è un TRACE POINT
%   x   è un CLUSTER POINT
%   p   è un FALSE TRACE POINT
%
%  ES. 1         ES. 2         ES. 3        ES. 4
%   o             o              p              p
%    xx            xp            xx           xxx
%     xp            x            xx          o  x
%    o               o            p             o
%
%
% Sebbene, come anticipato precedentemente, i FALSE TRACE POINT dovrebbero
% essere trattati come END POINT, conviene "eliminarli" e diminuire il
% clusterRank al numero di TRACE POINT rimasti.
% Così, ad esempio, se prendiamo il primo esempio (ES. 1), vediamo che il
% numero di TRACE POINT è 3, il clusterRank = 4 e il numero di FALSE TRACE
% POINT è 1. Il clusterRank viene dunque portato a
%      clusterRank = (#TRACE_POINT - #FALSE_TRACE_POINT) = 2
% in questo caso pari a 2 e viene risolto come un cluster di rango pari.
% Nel caso del terzo esempio, il numero di TRACE POINT è 2, e il numero di
% FALSE TRACE POINT è 2, dunque:
%      clusterRank = (#TRACE_POINT - #FALSE_TRACE_POINT) = 0
% Per cui va gestito il modo particolare.

% Come primo passo cerco i TRACE POINT connessi a 2 CLUSTER POINT e li
% classifico come FALSE TRACE POINT; iterativamente estendo la ricerca
% considerando anche i TRACE POINT connessi a FALSE TRACE POINT e a CLUSTER
% POINT oppure a 2 FALSE TRACE POINT.

%%% TROVO I TRACE POINT CONNESSI AL CLUSTER
% Definisco l'array di FALSE TRACE POINTS
FTP = PointsSet();

endCondition = true;
while endCondition
    [clusterRank, ~] = size(exitDirections);
    tracePoints = zeros(clusterRank, 2);
    
    FTPIndexes = [];
    
    addedFTP = false;
    for i = 1 : clusterRank
        currTracePoint = anchorBranchPoints(i,:) + exitDirections(i,:);
        possibleDirections = analyzeNeighbors(currTracePoint, image);
        [lengthPossibleDirections, ~] = size(possibleDirections);
        
        % Checking if it is a TRACE POINT --> lengthPossibleDirections == 2
        if lengthPossibleDirections == 2
            checkingFTP = false(1, 2);
            %currTPNeighbors = zeros(lengthPossibleDirections, 2);
            % Ottengo i vicini del TRACE POINT in esame e li analizzo
            for j = 1 : lengthPossibleDirections
                currTPNeighbor = currTracePoint + possibleDirections(j,:);
                % Checking if its neighbor is an ANCHOR BRANCH POINT
                [containedABP, ~] = belongsTo(currTPNeighbor, anchorBranchPoints, true);
                % Checking if its neighbor is a FALSE TRACE POINT
                [containedFTP, ~] = FTP.contains(currTPNeighbor);
                % Updating flag 
                checkingFTP(j) = containedABP | containedFTP;
                if checkingFTP(j) == false
                    % Check if its neighbor is a TRACE POINT that is
                    % connected to a FALSE TRACE POINT or ANCHOR BRANCH
                    % POINT or to another TRACE POINT with the same properties
                    exitDirection = getDirectionBetweenAdiacentPoint(currTracePoint, currTPNeighbor);
                    starter = currTPNeighbor;
                    [clusterFound, clusterFoundIndex, pxCounter, ~, ~, unfoldedArray] = traceFollowing_untilNextCluster(image, clusters, options, starter, exitDirection);
                    if clusterFound && clusterFoundIndex == clusterIndex && pxCounter < Thresholds.NUM_PIXELS_BROTHERHOOD
                        % Aggiungo tutti tranne l'ultimo, così che sia
                        % visto come ANCHOR BRANCH POINT da eliminare anche
                        % quello dall'altra estremità (quando sarà il suo
                        % turno)
                        FTP.add(unfoldedArray(1:end-1,:));
                        checkingFTP(j) = true;
                    end
                end
            end
            if sum(checkingFTP) == 2
                addedFTP = true;
                FTPIndexes = [FTPIndexes; i];
                FTP.add(currTracePoint);
            end
        end
    end
    
    if addedFTP == false
        endCondition = false;
    end
    
    tracePoints(FTPIndexes,:) = [];
    anchorBranchPoints(FTPIndexes,:) = [];
    exitDirections(FTPIndexes,:) = [];
end

falseTracePoints = FTP.points;
[clusterRank, ~] = size(exitDirections);


logger.debug('Anchor Branch Points computed. ');
for i = 1 : clusterRank 
    logger.debug('ABP %d: [%d %d]; ', i, anchorBranchPoints(i,:)');
    image = setAnchorBranchPoint(image, anchorBranchPoints(i,:), clusterIndex);
end
logger.debug('Exit directions computed.');
for i = 1 : clusterRank 
    logger.debug('ED %d: [%d %d]; ', i, exitDirections(i,:)');
end
logger.debug('False Trace Point computed.');
[lengthFTP, ~] = size(falseTracePoints);
for i = 1 : lengthFTP 
    logger.debug('FTP %d: [%d %d]; ', i, falseTracePoints(i,:)');
    image = setFalseTracePoint(image, falseTracePoints(i,:), clusterIndex);
end
logger.debug('Cluster rank: %d.', clusterRank);


%%% Updating cluster information
clusters(clusterIndex).anchorBP = anchorBranchPoints;
clusters(clusterIndex).exitDirections = exitDirections;
clusters(clusterIndex).falseTracePoints = falseTracePoints;
clusters(clusterIndex).clusterRank = clusterRank;

end







