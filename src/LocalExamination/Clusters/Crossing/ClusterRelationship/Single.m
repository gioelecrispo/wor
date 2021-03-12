classdef Single < SingleClusterRelationship & handle
   properties
   end
   methods
       function obj = Single(pairedIndexes, paths)
           obj = obj@SingleClusterRelationship;
           obj.pairedIndexes = pairedIndexes;
           obj.paths = paths;
       end
       function [nextIndex, path] = crossCluster(obj, index, clusters)
           crossCluster@SingleClusterRelationship(obj, index, clusters);
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