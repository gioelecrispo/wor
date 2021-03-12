classdef Parenthood < AggregatedClusterRelationship & handle
    properties
        
    end
    methods
        function obj = Parenthood()
            obj = obj@AggregatedClusterRelationship;
        end
        function obj = addChild(obj, child, childIndexes)
            obj.children(end+1) = child;
            obj.childrenIndexes{end+1} = childIndexes;
        end
        function [nextIndex, path] = crossCluster(obj, index, clusters)
            [nextIndex, path] = crossCluster@AggregatedClusterRelationship(obj, index, clusters);
            % Ottieni l'ID e gli indici associati al figlio
            [childID, child_index] = obj.retrieveChildIndexes(index);
            child = clusters(childID);
            % Richiama la funzione di attraversamento del figlio, in modo da
            % ottenere il suo nextIndex; bisogna poi rieffettuare il mapping
            % per ottenere il nextIndex del padre.
            if ~isempty(child.relationship)
                [child_nextIndex, path] = child.relationship.crossCluster(child_index, clusters);
                nextIndex = obj.retrieveFatherIndexFromChild(childID, child_nextIndex);
            end
        end
        function [childID, child_index] = retrieveChildIndexes(obj, index)
            for i = 1 : length(obj.childrenIndexes)
                childIndexes = obj.childrenIndexes{i};
                child_index = find(childIndexes == index, 1);
                if ~isempty(child_index)
                    break;
                end
            end
            childID = obj.children(i);
        end
        function father_index = retrieveFatherIndexFromChild(obj, childID, child_index)
            position = obj.children == childID;
            childIndexes = obj.childrenIndexes{position};
            father_index = childIndexes(child_index);
        end
    end
    
end