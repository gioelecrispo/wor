classdef Solo < SingleClusterRelationship & handle
    % SOLO: Una ClusterRelationship di tipo "SOLO" è una particolare specie
    %       di relazione in cui cluster trova un "accoppiamento" con sé
    %       stesso. E' il caso del retracing.
    %        
    %        1 ___
    %             \__ 3  retracing
    %        2 ___/ 
    %%%%%
    properties
        % retracingIndex: indica l'anchorBP di retracing. Per come è
        %                 definito si trova sempre nella prima colonna della
        %                 matrice pairedIndexes.
        %                     pairedIndexes = [3  1;       3 è l'anchorBP
        %                                      3  2];       di retracing
        retracingIndex
        arrivedFrom
    end
    methods
        function obj = Solo(pairedIndexes, paths)
            obj = obj@SingleClusterRelationship;
            obj.retracingIndex = pairedIndexes(1,1);
            obj.pairedIndexes = pairedIndexes;
            obj.paths = paths;
            obj.arrivedFrom = [];
        end
        function [nextIndex, path] = crossCluster(obj, index, clusters)
            crossCluster@SingleClusterRelationship(obj, index, clusters);
            if index == obj.retracingIndex
                if ~isempty(obj.arrivedFrom)
                    filterIndexes = (obj.pairedIndexes(:,2) ~= obj.arrivedFrom);
                    nextIndex = obj.pairedIndexes(filterIndexes, 2);
                    path = obj.paths{filterIndexes};
                    obj.arrivedFrom = [];
                else
                    error('SOLO: passing through retracing index without defining "arrivedFrom"')
                end
            else
                filterIndexes = (obj.pairedIndexes(:,2) == index);
                nextIndex = obj.retracingIndex;
                path = obj.paths{filterIndexes};
                obj.arrivedFrom = index;
            end
        end
    end
end