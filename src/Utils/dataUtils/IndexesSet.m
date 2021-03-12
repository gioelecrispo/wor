classdef IndexesSet < handle
    %% PointsSet 
    properties
        indexes
    end
    methods
        function obj = IndexesSet()
            obj.indexes = [];
        end
        function bool = add(obj, elements)
            [lengthElements, ~] = size(elements);
            for i = 1 : lengthElements
                [contained, ~] = obj.contains(elements(i,:));
                if ~contained
                    obj.indexes = [obj.indexes; elements(i,:)];
                end
                bool = ~contained;
            end
        end
        function contained = remove(obj, element)
            [contained, position] = obj.contains(element);
            if contained
                obj.points(position,:) = [];
            end
        end
        function [bool, i] = contains(obj, element)
            bool = false;
            lengthPoints = length(obj);
            for i = 1 : lengthPoints
                lengthElement = length(element);
                lsum = false(1, lengthElement);
                for j = 1 : lengthElement
                   lsum = lsum | (obj.indexes(i,:) == element(j));
                end
                if sum(lsum) == lengthElement
                    bool = true;
                    break;
                end
            end
        end
        function lengthPoints = length(obj)
            [lengthPoints, ~] = size(obj.indexes);
        end
        function bool = isempty(obj)
            bool = isempty(obj.indexes); 
        end
    end
    
end

