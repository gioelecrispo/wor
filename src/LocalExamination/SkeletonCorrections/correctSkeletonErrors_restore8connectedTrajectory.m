function [image, clusters, modified] = correctSkeletonErrors_restore8connectedTrajectory(clusterIndex, image, clusters) 

modified = false; 


%%% OTTENIMENTO INFO CLUSTER
pixels = clusters(clusterIndex).pixels;
anchorBP = clusters(clusterIndex).anchorBP;
exitDirections = clusters(clusterIndex).exitDirections;
clusterRank = clusters(clusterIndex).clusterRank;

%%% CONTROLLO IL NUMERO DI TRACE POINT/END POINT DI USCITA
% Un ANCHOR BP è per definizione un punto del cluster connesso ad un TRACE
% POINT oppure ad un END POINT.
% Per questo motivo il rango del cluster viene definito come il numero di
% ANCHOR POINT. 
% A volte però può capitare, per una cattiva scheletonizzazione che il
% numero di TRACE POINT/END POINT di uscita dal cluster sia diverso dal
% rango del cluster.
% Analizzando gli END POINT/TRACE POINT di uscita notiamo che:
%  - END POINT (1 vicino):
%       - connesso solo ad un cluster point.
%  - TRACE POINT (2 vicini):
%       - connesso ad un cluster point e ad un altro trace point;
%       - connesso ad un cluster point e ad un cluster point di un altro
%         cluster;
%       - connesso a due cluster point dello stesso cluster.
% Quest'ultimo caso è quello problematico: lo definiamo per semplicità
% FALSE TRACE POINT e va trattato alla stregua di un END POINT.
%
% ESEMPI: 
% Tenendo conto che:
%   o   è un TRACE POINT
%   x   è un CLUSTER POINT
%   p   è un FALSE TRACE POINT
%
%  ES. 1         ES. 2         ES. 3        ES. 4 
%   o             o              p              p
%    xx            xp            xx           xxx
%     xp            x            xx          o  x 
%    o               o            p             o
%
%
% Sebbene, come anticipato precedentemente, i FALSE TRACE POINT dovrebbero
% essere trattati come END POINT, conviene "eliminarli" e diminuire il
% clusterRank al numero di TRACE POINT rimasti.
% Così, ad esempio, se prendiamo il primo esempio (ES. 1), vediamo che il
% numero di TRACE POINT è 3, il clusterRank = 4 e il numero di FALSE TRACE
% POINT è 1. Il clusterRank viene dunque portato a 
%      clusterRank = (#TRACE_POINT - #FALSE_TRACE_POINT) = 2
% in questo caso pari a 2 e viene risolto come un cluster di rango pari.
% Nel caso del terzo esempio, il numero di TRACE POINT è 2, e il numero di
% FALSE TRACE POINT è 2, dunque:
%      clusterRank = (#TRACE_POINT - #FALSE_TRACE_POINT) = 0
% Per cui va gestito il modo particolare.

%% TROVO I TRACE POINT CONNESSI AL CLUSTER
tracePoints = zeros(clusterRank, 2);
falseTracePoint = [];
duplicateIndexes = [];
for i = 1 : clusterRank 
    newPixel = anchorBP(i,:) + exitDirections(i,:);
    [contained, j] = belongsTo(newPixel, tracePoints);
    tracePoints(i,:) = newPixel;
    if contained
        duplicateIndexes = [duplicateIndexes; j i];
        falseTracePoint = [falseTracePoint; newPixel]; 
    end
end

realTracePoints = tracePoints;
realAnchorBP = anchorBP;
realExitDirections = exitDirections;
realTracePoints(duplicateIndexes,:) = [];
realAnchorBP(duplicateIndexes,:) = [];
realExitDirections(duplicateIndexes,:) = [];
[realClusterRank, ~] = size(realExitDirections);