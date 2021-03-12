function [retracingAnchorBP, vertex] = findVertexOppositeToMinAngle(adiacency, allContributes, anchorBP)

vertex = NaN;
retracingAnchorBP = [NaN NaN];


[minAngle, minIndex] = min(allContributes);
if minAngle*100/360 < Thresholds.RETRACING_MAX_ANGLE_WIDENESS
    i = adiacency(minIndex,1);
    j = adiacency(minIndex,2);
    verteces = 1 : 3;
    verteces([i,j]) = [];
    
    vertex = verteces;
    retracingAnchorBP = anchorBP(vertex,:);
end
    

end