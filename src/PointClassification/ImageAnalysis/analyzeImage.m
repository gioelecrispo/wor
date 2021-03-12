function image = analyzeImage(image, options)
% Locate Branch Points, Trace Points and End Points in the binary image bw.
% The function returns the image structure, with a new field:
% - pointsMatrix.
%
% pointsMatrix is ??a support matrix that takes into account the number of neighbors
% of each skeleton point, in order to register all the salient points
% (endPoint, brachPoint, etc) of the survey; more specifically the
% classification is as follows:
% - BACKGROUND = 0
% is not a skeleton px.
% - END POINT = 1
% a px of the skeleton with only 1 neighbor.
% - TRACE POINT = 2
% a px of the skeleton with 2 neighbors.
% - BRANCH POINT = rank (3, 4, 5, 6, 7, 8)
% a px of the skeleton with 3 or more neighbors.
%
% In particular pointsMatrix is a tridimensional matrix, r x c x 7, where
% r and c are respectively the rows and columns of the image and 7 is the
% number of the specific information we need.

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
%
% BUILD SUPPORT MATRICES
% To build the pointMatrix, we have to analyze the neighbors of each pixel
% of the skeleton (PointType.BLACK) to get the above classification.




bw = image.bw;
[rows, cols] = size(bw);
pointsMatrix = NaN(rows, cols, 7);
image.pointsMatrix = pointsMatrix;
%toolMatrix = zeros(rows, cols);
%branchPointsMatrix = zeros(rows, cols);
for y = 1 : cols
    for x = 1 : rows
        currPixelValue = bw(x,y);
        neighbor_count = 0; 
        % if the pixel is a skeleton pixel, evaluate the neighbors
        if currPixelValue == PointType.BLACK 
            % neighboors
            if x ~= 1  % first row -> no up 
               neighbor_up_value = bw(x-1,y);
               if neighbor_up_value == PointType.BLACK
                    neighbor_count = neighbor_count + 1;
               end
            end
            if x ~= rows % last row -> no down
                neighbor_down = bw(x+1,y);
                if neighbor_down == PointType.BLACK
                    neighbor_count = neighbor_count + 1;
                end
            end
            if y ~= 1 % first column -> no left
                neighbor_left_value = bw(x,y-1);
                if neighbor_left_value == PointType.BLACK
                    neighbor_count = neighbor_count + 1;
                end
            end
            if y ~= cols % last column -> no right
                neighbor_right_value = bw(x,y+1);
                if neighbor_right_value == PointType.BLACK
                    neighbor_count = neighbor_count + 1;
                end
            end
            if x ~= 1 && y ~= 1 % first pixel of the first row -> no up-left
                neighbor_up_left = bw(x-1,y-1);
                if neighbor_up_left == PointType.BLACK
                    neighbor_count = neighbor_count + 1;
                end
            end
            if x ~= 1 && y ~= cols % last pixel of the first row -> no up-right
                neighbor_up_right = bw(x-1,y+1);
                if neighbor_up_right == PointType.BLACK
                    neighbor_count = neighbor_count + 1;
                end
            end
            if x ~= rows && y ~= 1 % first pixel of the last row -> no down-left
                neighbor_down_left_value = bw(x+1,y-1);
                if neighbor_down_left_value == PointType.BLACK
                    neighbor_count = neighbor_count + 1;
                end
            end
            if x ~= rows && y ~= cols % last pixel of the last row -> no down-right
                neighbor_down_right = bw(x+1,y+1);
                if neighbor_down_right == PointType.BLACK
                    neighbor_count = neighbor_count + 1;
                end
            end
            if neighbor_count == 0 || neighbor_count == 1
                %toolMatrix(x,y) = PointType.END_POINT;
                image = setEndPoint(image, [x, y]);
            elseif neighbor_count == 2
                %toolMatrix(x,y) = PointType.TRACE_POINT;
                image = setTracePoint(image, [x, y]);
            elseif neighbor_count >= 3
                %toolMatrix(x,y) = neighbor_count;
                %branchPointsMatrix(x,y) = neighbor_count;
                image = setBranchPoint(image, [x, y], NaN);
            end
        end
    end
end

%image.toolMatrix = toolMatrix;
%image.branchPointsMatrix = branchPointsMatrix;

logger = getLogger(options);
logger.info('Image dimensions: %d rows, %d cols', rows, cols);
logger.debug('Analysis complete. image.pointsMatrix created.')
end





