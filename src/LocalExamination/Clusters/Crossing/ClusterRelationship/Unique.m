classdef Unique < SingleClusterRelationship & handle
    % UNIQUE: Una ClusterRelationship di tipo "UNIQUE" è una particolare specie
    %       di relazione in cui cluster trova un "accoppiamento" con sé
    %       stesso. E' il caso del cluster di rank == 1.
    %                ___
    %        1 _____|_|_|
    %               |_|_|
    %%%%%
    properties
        starter
        retracing
    end
    methods
        function obj = Unique(pairedIndexes, paths)
            obj = obj@SingleClusterRelationship;
            obj.pairedIndexes = pairedIndexes;
            obj.paths = paths;
            obj.starter = false;
            obj.retracing = false;
        end
        function [nextIndex, path] = crossCluster(obj, index, clusters)
            crossCluster@SingleClusterRelationship(obj, index, clusters);
            if obj.starter == true || obj.retracing == true
                nextIndex = 1;
            else
                nextIndex = NaN;
            end
            path = obj.paths{1};
        end
    end
end