classdef PointClassificationType
    properties (Constant)
        % CLASSIFICATION POINT TYPES
        END_POINT                  =  1;            
        RETRACING_POINT            =  2;
        TRACE_POINT                =  3;
        FALSE_TRACE_POINT          =  4;
        BRANCH_POINT               =  5;
        ANCHOR_BRANCH_POINT        =  6;
        BELONGING_CLUSTER          =  7;
        
        % COLOR TYPES
        BLACK = 0;     % skeleton
        WHITE = 1;     % background
    end
    
    methods (Static)
       
    end
end