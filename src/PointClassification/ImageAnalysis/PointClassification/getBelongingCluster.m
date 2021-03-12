function belongingCluster = getBelongingCluster(image, point)
% GET BELONGING CLUSTER
% image.pointsMatrix is a powerful matrix that contains all the information
% needed about points in the image. It provides full and rapid access to
% the point type.
% IMPORTANT. pointsMatrix is a 3-dimensional array, for which:
%  - the first dimension represents the x-coordinate
%  - the second dimension represents the y-coordinate
%  - the third dimension contains the info about the point.
% The third dimension is a [1,7] integer array for which the numbers 
% indicates respectively:
%  - EP:  [END POINT] if that point is an END POINT;
%  - RP:  [RETRACING POINT] if that point is an RETRACING POINT;
%  - TP:  [TRACE POINT] if that point is an TRACE POINT;
%  - FTP: [FALSE TRACE POINT] if that point is an FALSE TRACE POINT;
%  - BP:  [BRANCH POINT] if that point is an BRANCH POINT;
%  - ABP: [ANCHOR BRANCH POINT] if that point is an ANCHOR BRANCH POINT;
%  - BC:  [BELONGING CLUSTER] indicates the beloging cluster (NaN if is the
%  point is not a BP or FTP or ABP.

belongingCluster = image.pointsMatrix(point(1), point(2), PointClassificationType.BELONGING_CLUSTER);
