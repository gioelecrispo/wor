%% AssociatedPoints
classdef AssociatedPoints < handle
    properties
        pairedPoints
    end
    methods
        function obj = AssociatedPoints()
            obj.pairedPoints = [];
        end
        function bool = add(obj, points)
            [lengthPoints, ~] = size(points);
            bool = false;
            if lengthPoints == 2
                obj.pairedPoints(:,:,length(obj)+1) = points;
                bool = true;
            end
        end
        function numElements = length(obj)
            [~, ~, numElements] = size(obj.pairedPoints);
        end
        function permutations = permute(obj)
            numElements = length(obj);
            permutations = perms(1:numElements);
        end
        function nc = computeNumCombinations(obj, numElements)
            if numElements == 0 
                nc = 1;   % caso base
            else
                nc = numElements * 2 * computeNumCombinations(obj, numElements-1);
            end
        end
    end    
end