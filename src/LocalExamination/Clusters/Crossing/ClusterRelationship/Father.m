classdef Father < Parenthood & handle
    properties
        
    end
    methods
        function obj = Father()
            obj = obj@Parenthood;
        end
        function obj = addChild(obj, child, childIndexes)
            obj.children(end+1) = child;
            obj.childrenIndexes{end+1} = childIndexes;
        end
        function [obj, clusters] = crossCluster(obj, index, clusters)
            % Ottieni l'ID e gli indici associati al figlio
            [childID, child_index] = obj.retrieveChildIndexes(index);
            child = clusters(childID);
            % Richiama la funzione di attraversamento del figlio, in modo da
            % ottenere il suo nextIndex; bisogna poi rieffettuare il mapping
            % per ottenere il nextIndex del padre.
            if ~isempty(child.relationship)
                child.relationship.singleClusterRelationship.crossCluster(child_index, clusters);
                obj.nextIndex = obj.retrieveFatherIndexFromChild(childID, child.relationship.nextIndex);
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