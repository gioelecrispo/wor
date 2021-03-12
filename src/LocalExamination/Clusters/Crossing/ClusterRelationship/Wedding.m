classdef Wedding < SingleClusterRelationship & handle
   properties
       connectedCluster
       sharedIndexes
       connectedIndexes
       arrivedFrom
   end
   methods
       function obj = Wedding(pairedIndexes, connectedClusterIndex, sharedIndexes, connectedIndexes, paths)
           obj = obj@SingleClusterRelationship;
           obj.pairedIndexes = pairedIndexes;
           obj.connectedCluster = connectedClusterIndex;
           obj.sharedIndexes = sharedIndexes;
           obj.connectedIndexes = connectedIndexes;
           obj.paths = paths;
           obj.arrivedFrom = [];
       end
       function [nextIndex, path] = crossCluster(obj, index, clusters)
           crossCluster@SingleClusterRelationship(obj, index, clusters);
           wedding_married = clusters(obj.connectedCluster).relationship; 
           arrivedFrom_married = wedding_married.arrivedFrom;
           
           if ~isempty(arrivedFrom_married) && index == obj.sharedIndexes(1)
               wedding_married.arrivedFrom = [];
               connfilterIndexes = (obj.connectedIndexes(:,2) == arrivedFrom_married);
               nextIndex = obj.connectedIndexes(connfilterIndexes, 1); 
               filterIndexes = (obj.pairedIndexes == nextIndex);
               [r, ~] = find(filterIndexes);
               path = obj.paths{r};
           else
               obj.arrivedFrom = index;
               filterIndexes = (obj.pairedIndexes == index);
               [r, c] = find(filterIndexes);
               if c == 1
                   nextIndex = obj.pairedIndexes(r,2);
               else
                   nextIndex = obj.pairedIndexes(r,1);
               end
               path = obj.paths{r};
           end
       end
   end   
end