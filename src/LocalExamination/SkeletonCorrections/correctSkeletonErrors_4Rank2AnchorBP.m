function [image, clusters, modified] = correctSkeletonErrors_4Rank2AnchorBP(clusterIndex, image, clusters)

modified = false;

%%% OTTENGO INFO CLUSTER
pixels = clusters(clusterIndex).pixels;
anchorBP = clusters(clusterIndex).anchorBP;
exitDirections = clusters(clusterIndex).exitDirections;
clusterRank = clusters(clusterIndex).clusterRank;

[lengthCluster, ~] = size(pixels);




% Se il cluster è di rango 4 e ha 2 pixels di cui 2 anchorBP
if clusterRank == 4
    sameAnchorBP = zeros(clusterRank, 2);
    for i = 1 : clusterRank
        for j = i : clusterRank
            if i ~=j && isTheSamePoint(anchorBP(i,:), anchorBP(j,:))
                sameAnchorBP(i,:) = [i, j];
            end
        end
    end
    deletion = sameAnchorBP(:,1)==0 & sameAnchorBP(:,2)==0;
    sameAnchorBP(deletion,:) = [];
    
    [lengthSameAnchorBP, ~] = size(sameAnchorBP);
    if lengthSameAnchorBP == 2 && lengthCluster == 2
        anchorBP1 = anchorBP(sameAnchorBP(1,1),:);
        anchorBP2 = anchorBP(sameAnchorBP(2,1),:);
        distance = abs(anchorBP1 - anchorBP2);
        if sum(distance == [1 1]) == 2
            nextPx = zeros(lengthSameAnchorBP, 4);
            for i = 1 : lengthSameAnchorBP
                nextPx(i,1:2) = anchorBP(sameAnchorBP(i,1),:) + exitDirections(sameAnchorBP(i,1),:);
                nextPx(i,3:4) = anchorBP(sameAnchorBP(i,2),:) + exitDirections(sameAnchorBP(i,2),:);
            end
            
            
            %%% TROVA I PX COMPATIBILI
            for i = 1 : lengthSameAnchorBP
                px1 = nextPx(i,1:2);
                px2 = nextPx(i,3:4);
                commonPoints = findNeighborPoints(px1, px2);
                [lengthCommonPoints, ~] = size(commonPoints);
                for j = 1 : lengthCommonPoints
                    if ~isTheSamePoint(commonPoints(j,:), anchorBP(sameAnchorBP(j,1),:))
                        modified = true;
                        image.bw(commonPoints(j,1), commonPoints(j,2)) = PointType.BLACK;
                        %image = setTracePoint(image, commonPoints(j,:));
                        image.bw(anchorBP(sameAnchorBP(j,1),1), anchorBP(sameAnchorBP(j,1),2)) = PointType.WHITE;
                        %image = setNoSkeletonPoint(image, anchorBP(sameAnchorBP(j,1),:));
                        break;
                    end
                end
            end
        end
    end
end




end
