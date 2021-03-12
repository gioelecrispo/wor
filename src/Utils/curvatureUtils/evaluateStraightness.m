function isStraight = evaluateStraightness(points, numPoints, aroundness)

    [segCurv, ~, ~] = evaluateCurvatureMultiscale(points, numPoints, aroundness);
   
    isStraight = segCurv <= Thresholds.RETRACING_MAX_SEGMENT_CURVATURE;
    
end