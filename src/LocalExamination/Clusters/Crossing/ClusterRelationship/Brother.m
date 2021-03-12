classdef Brother < FederatedClusterRelationship & handle
   properties
       brotherhood
   end
   methods
       function obj = Brother(brotherhood)
           obj = obj@FederatedClusterRelationship;
           obj.brotherhood = brotherhood;
       end
       function [nextIndex, path] = crossCluster(obj, index, clusters)
           [nextIndex, path] = crossCluster@FederatedClusterRelationship(obj, index, clusters);
           brotherhood_cluster = clusters(obj.brotherhood);
           if ~isempty(brotherhood_cluster.relationship)
               [nextIndex,path] = brotherhood_cluster.relationship.crossCluster(index, clusters);
           end
       end
   end   
end