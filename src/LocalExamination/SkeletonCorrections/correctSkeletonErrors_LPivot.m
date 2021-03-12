function [image, modified] = correctSkeletonErrors_LPivot(clusterIndex, image, clusters)

modified = false;
pixels = clusters(clusterIndex).pixels;

pairsPixel = [];
[clusterLength, ~] = size(pixels);
for i = 1 : clusterLength
    currPixel = pixels(i,:);
    for j = 1 : clusterLength
        if ~isTheSamePoint(currPixel, pixels(j,:))
            distance = abs(currPixel - pixels(j,:));
            if sum(distance == [1  1]) == 2
                pairToAdd = [currPixel, pixels(j,:)];
                if ~containedInPairsPixel(pairsPixel, pairToAdd)
                    pairsPixel = [pairsPixel; pairToAdd];
                end
            end
        end
    end
end


[pairs, ~] = size(pairsPixel);
for i = 1 : pairs
   px1 = pairsPixel(i,1:2);
   px2 = pairsPixel(i,3:4);
   possibleDirections_px1 = analyzeNeighbors(px1, image);
   possibleDirections_px2 = analyzeNeighbors(px2, image);
   neighbors_px1 = [];
   neighbors_px2 = [];
   for k = 1 : length(possibleDirections_px1)
      neighbors_px1 = [neighbors_px1; px1 + possibleDirections_px1(k,:)]; 
   end
   for k = 1 : length(possibleDirections_px2)
      neighbors_px2 = [neighbors_px2; px2 + possibleDirections_px2(k,:)]; 
   end
   commons = findCommonNeighbors(neighbors_px1, neighbors_px2);
   [numCommons, ~] = size(commons);
   if numCommons == 1
       cmx = commons(1);
       cmy = commons(2); 
       if isTracePoint(image, [cmx, cmy]) % image.toolMatrix(cmx, cmy) == PointType.TRACE_POINT 
           image.bw(cmx, cmy) = PointType.WHITE; 
           %image = setNoSkeletonPoint(image, [cmx, cmy]);
           modified = true;
       end
   end
end


end




%% findCommonNeighbors
% E' una funzione che 
function commons = findCommonNeighbors(neighbors_px1, neighbors_px2)

commons = [];
for i = 1 : length(neighbors_px1)
    for j = 1 : length(neighbors_px2)
        if isTheSamePoint(neighbors_px1(i,:), neighbors_px2(j,:))
            commons = [commons; neighbors_px1(i,:)];
        end
    end
end

end



function bool = containedInPairsPixel(pairsPixel, pairToAdd)
    [lengthPairsPixel, ~] = size(pairsPixel);
    invertedPairToAdd = [pairToAdd(3:4) pairToAdd(1:2)];
    bool = false;
    for i = 1 : lengthPairsPixel
         if sum(pairsPixel(i,:) == invertedPairToAdd) == 4
             bool = true;
         end
    end
end