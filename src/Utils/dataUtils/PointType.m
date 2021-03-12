classdef PointType
    properties (Constant)
        % POINT TYPES
        NO_SKELETON          =  0;
        ISOLATED_POINT       =  0;            
        END_POINT            =  1;
        TRACE_POINT          =  2;
        BRANCH_POINT         =  [3 8];
        RETRACING_POINT      = -1;
        CLUSTER_END_POINT    = -2;
        
        % COLOR TYPES
        BLACK = 0;     % skeleton
        WHITE = 1;     % background
    end
    
    methods (Static)
        function bool = isNoSkeleton(point, image)
            bool = image.toolMatrix(point(1), point(2)) == PointType.NO_SKELETON;
        end
        function bool = isEndPoint(point, image)
            bool = image.toolMatrix(point(1), point(2)) == PointType.END_POINT ... 
                || image.toolMatrix(point(1), point(2)) == PointType.CLUSTER_END_POINT;
        end
        function bool = isTracePoint(point, image)
            bool = image.toolMatrix(point(1), point(2)) == PointType.TRACE_POINT;
        end
        function bool = isRetracingPoint(point, image)
            bool = image.toolMatrix(point(1), point(2)) == PointType.RETRACING_POINT;
        end
        function bool = isBranchPoint(point, image)
            bool = image.toolMatrix(point(1), point(2)) >= PointType.BRANCH_POINT(1) ... 
                && image.toolMatrix(point(1), point(2)) <= PointType.BRANCH_POINT(2);
        end
        function endPoints = findEndPoints(image)
            [endX, endY] = find(image.toolMatrix == PointType.END_POINT | image.toolMatrix == PointType.CLUSTER_END_POINT);
            endPoints = [endX, endY];
        end
        function retracingPoints = findRetracingPoints(image)
            [retrX, retrY] = find(image.toolMatrix == PointType.RETRACING_POINT);
            retracingPoints = [retrX, retrY];
        end
    end
end