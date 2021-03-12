classdef (Abstract) SingleClusterRelationship < ClusterRelationship & handle & matlab.mixin.Heterogeneous
    properties
        pairedIndexes
        paths
    end
    methods
        function obj = SingleClusterRelationship()
            obj = obj@ClusterRelationship;
            obj.pairedIndexes = [];
            obj.paths = [];
        end
        function [nextIndex, path] = crossCluster(obj, index, clusters)
            [nextIndex, path] = crossCluster@ClusterRelationship(obj, index, clusters);
            obj.checkInputIndex(index);
        end
        function [] = checkInputIndex(obj, index)
            totalIndexes = unique(obj.pairedIndexes)';
            checkArray = totalIndexes == index;
            if sum(checkArray) == 0
                error('CROSS_CLUSTER: invalid input index.');
            end
        end
    end
end