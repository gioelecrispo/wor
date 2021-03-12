classdef (Abstract) ClusterRelationship < handle
    properties
    end
    methods
        function obj = ClusterRelationship()
            
        end
        function [nextIndex, path] = crossCluster(obj, index, clusters)
            nextIndex = [];      
            path = [];
        end
    end
end