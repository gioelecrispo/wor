classdef Child < Parenthood & handle
    properties
        fatherIndex
        parenthoodIndex
        singleClusterRelationship
    end
    methods
        function obj = Child(fatherIndex)
            obj = obj@Parenthood;
            obj.fatherIndex = fatherIndex;
        end
        function obj = setSingleClusterRelationship(obj, singleClusterRelationship)
            obj.singleClusterRelationship = singleClusterRelationship;
        end
        function [obj, clusters] = crossCluster(obj, index, clusters)
            % Ottieni l'ID associato al padre e il mapping degli indici
            father = clusters(obj.fatherIndex);
            father_index = retrieveFatherIndexFromChild(obj.parenthoodIndex, index);
            % Richiama la funzione di attraversamento del figlio, in modo da
            % ottenere il suo nextIndex; bisogna poi rieffettuare il mapping
            % per ottenere il nextIndex del padre.
            [obj, clusters] = father.relationship.crossCluster(obj, father_index, clusters);

        end
    end
    
end