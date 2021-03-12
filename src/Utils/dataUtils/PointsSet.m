%% PointsSet
classdef PointsSet < handle
    properties
        points
    end
    methods
        function obj = PointsSet()
            obj.points = [];
        end
        function bool = add(obj, elements)
            [lengthElements, ~] = size(elements);
            for i = 1 : lengthElements
                [contained, ~] = obj.contains(elements(i,:));
                if ~contained
                    obj.points = [obj.points; elements(i,:)];
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
                if isTheSamePoint(obj.points(i,:), element)
                    bool = true;
                    break;
                end
            end
        end
        function lengthPoints = length(obj)
            [lengthPoints, ~] = size(obj.points);
        end
        function bool = isempty(obj)
            bool = isempty(obj.points); 
        end
        function [] = clear(obj)
            obj.points = [];
        end
    end
    
end