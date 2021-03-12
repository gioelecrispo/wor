function [image, clusters, modif] = correctSkeletonErrors_3Connected3(clusterIndex, image, clusters)
% La funzione analizza il cluster definito da clusterIndex al fine di
% cercare il pattern 3 parallel 3, che coinvolge 2 clusters privi di 
% informazione e che vanno eliminati. Il pattern in questione è
% rappresentato dal seguente schema:
%     ____
%  __/    \___     correz.       ___________
%    \____/       -------->
%              
% In pratica, preso un cluster di rango 3, si cerca un altro cluster di
% rango 3 ad esso connesso tale che comunichino attraverso 2 rami. Se ciò
% succede, i rami vanno eliminati e va tracciata una retta che congiunge i
% due anchorBP rimasti.
if clusterIndex == 8
   1 
end

modif = false;
anchorBP = clusters(clusterIndex).anchorBP;
exitDirections = clusters(clusterIndex).exitDirections;
clusterRank = clusters(clusterIndex).clusterRank;

clusterFoundIndexes = zeros(clusterRank, 1);
nearestAnchorBPIndexes = zeros(clusterRank, 1);
for i = 1 : clusterRank
    bp = anchorBP(i,:);
    exitDirection = exitDirections(i,:);
    starter = bp + exitDirection;
    [clusterFound, ~, ~, anchorBPIndex, clusterFoundIndex] = traceFollowing_untilNextCluster(image, clusters, starter, exitDirection);
    if clusterFound && clusters(clusterFoundIndex).clusterRank == 3
        clusterFoundIndexes(i) = clusterFoundIndex;
        nearestAnchorBPIndexes(i) = anchorBPIndex;
    end
end


uniqueVals = unique(clusterFoundIndexes);
valCount = hist(clusterFoundIndexes, uniqueVals);
[maxValue, maxIndex] = max(valCount);
if maxValue >= 2
    connectedCluster = uniqueVals(maxIndex);
    if connectedCluster ~= 0
        modif = true;
        nearestAnchorBP = clusters(connectedCluster).anchorBP;
        %nearestDirectionsOutsideCluster = clusters(connectedCluster).directionsOutsideCluster;
        unconnectedAnchorBPIndex = 1:clusterRank;
        unconnectedAnchorBPIndex(clusterFoundIndexes == connectedCluster) = [];
        nearestAnchorBPIndexes(clusterFoundIndexes ~= connectedCluster) = [];
        nearestUnconnectedAnchorBPIndex = 1:clusterRank;
        nearestUnconnectedAnchorBPIndex(nearestAnchorBPIndexes) = [];
        unconnectedAnchorBP = anchorBP(unconnectedAnchorBPIndex,:);
        nearestUnconnectedAnchorBP = nearestAnchorBP(nearestUnconnectedAnchorBPIndex,:);
        
      
        % CANCELLAZIONE PERCORSI INUTILI
        anchorBPIndexes = 1:clusterRank;
        anchorBPIndexes(clusterFoundIndexes ~= connectedCluster) = [];
        for i = 1 : length(anchorBPIndexes)
            point = anchorBP(anchorBPIndexes(i),:);
            exitDirection = exitDirections(anchorBPIndexes(i),:);
            currPixel = point + exitDirection;
            lastPointToDelete = nearestAnchorBP(nearestAnchorBPIndexes(i),:); % + nearestDirectionsOutsideCluster(nearestAnchorBPIndexes(i),:);
            oppositeDirection = computeOppositeDirection(exitDirection);
            while ~isTheSamePoint(currPixel, lastPointToDelete)
                [currPixel, direction, ~] = traceFollowing(image, clusters, currPixel, oppositeDirection);
                image.bw(currPixel(1), currPixel(2)) = PointType.WHITE;
                %image = setNoSkeletonPoint(image, currPixel);
                currPixel = currPixel + direction;
            end
        end
        
        
        % RETTA PASSANTE PER I DUE PUNTI TROVATI
        [slope, intercept] = rectBeetweenTwoPoint(unconnectedAnchorBP, nearestUnconnectedAnchorBP);
        xUC = unconnectedAnchorBP(1);
        xNUC = nearestUnconnectedAnchorBP(1);
        if xUC < xNUC
            x = xUC:1:xNUC;
        else
            x = xNUC:1:xUC;
        end
        y = round(slope*x + intercept);
        for i = 1 : length(x)
            %image.bw(x(i), y(i)) = PointType.BLACK;
            image = setTracePoint(image, [x, y]);
        end
        
        
        clusters(clusterIndex).delete = true;
        clusters(connectedCluster).delete = true;
    end
    
end