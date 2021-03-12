classdef QueueSet < handle
    properties
        container
        valid
    end
    methods
        function obj = QueueSet()
            obj.container = [];
            obj.valid = [];
        end
        function bool = add(obj, elements)
            [lengthElements, ~] = size(elements);
            for i = 1 : lengthElements
                [contained, ~] = obj.contains(elements(i));
                if ~contained
                    obj.container = [obj.container; elements(i)];
                    obj.valid = [obj.valid; true];
                end
                bool = ~contained;
            end
        end
        function contained = remove(obj, element)
            [contained, position] = obj.contains(element);
            if contained
                obj.container(position) = [];
            end
        end
        function element = head(obj)
            lengthSet = length(obj);
            for i = 1 : lengthSet
                if obj.valid(i) ~= false
                    element = obj.container(i);
                    obj.valid(i) = false;
                    break;
                else 
                    element = [];
                end
            end
        end
        function [bool, i] = contains(obj, element)
            bool = false;
            lengthSet = length(obj);
            for i = 1 : lengthSet
                if (obj.container(i,:) == element)
                    bool = true;
                    break;
                end
            end
        end
        function lengthSet = length(obj)
            [lengthSet, ~] = size(obj.container);
        end
        function bool = isempty(obj)
            bool = isempty(obj.container);
        end
        function bool = isInvalid(obj)
            bool = true;
            lengthSet = length(obj);
            for i = 1 : lengthSet
                if obj.valid(i) == true;
                    bool = false;
                    break;
                end
            end
        end
    end
end