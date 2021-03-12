classdef Brotherhood < FederatedClusterRelationship & handle
   properties
   end
   methods
       function obj = Brotherhood()
           obj = obj@FederatedClusterRelationship;
       end
       function obj = addComponent(obj, components, federation)
           obj.components = components; 
           obj.federation = federation; 
       end
       function [obj, nextIndex] = crossCluster(obj, index, clusters)
           [obj, nextIndex] = crossCluster@FederatedClusterRelationship(obj, index, clusters);
           nextIndex = obj.federation.crossCluster(index, clusters);
           obj.nextIndex = obj.federation.nextIndex;
       end
   end   
end