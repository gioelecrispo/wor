function  curvature = normalizeCurvature(curvature)

MIN_CIRCULAR_STD = 0;
MAX_CIRCULAR_STD = circularStd([0 90 180 270]);

curvature = curvature * 180 / MAX_CIRCULAR_STD;

end