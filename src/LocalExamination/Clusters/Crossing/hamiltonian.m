function path = hamiltonian(clusterIndex, clusters, source, destination)

pixels = clusters(clusterIndex).pixels;
falseTracePoints = clusters(clusterIndex).falseTracePoints;

clusterPoints = [pixels; falseTracePoints];

%%% CONTROLLO STRETTOIE 
% Se ci sono delle strettoie Hamilton fallisce, poiché non è pensato per
% passare 2 volte per lo stesso nodo. Si aggira il problema creando dei
% nodi duplicati in corrispondenza dei punti critici (strettoie).
[lengthClusterPoints, ~] = size(clusterPoints);
bottleneckVerteces = false(1, lengthClusterPoints);
for i = 1 : lengthClusterPoints
    cpoint = clusterPoints(i,:); 
    neighbors = analyzeClusterNeighbors(cpoint, clusterPoints);
    bottleneckVerteces(i) = isClusterBottleneck(neighbors);
end

if sum(bottleneckVerteces) == 0 
    % NON CI SONO STRETTOIE
    % Non si ha bisogno di ricomputare il grafo.
    graph = clusters(clusterIndex).graph;
else
    % CI SONO STRETTOIE
    % Bisogna aggiungere i nodi fittizi e ricomputare il grafo, aggiungendo
    % i punti critici.
    graph = clusters(clusterIndex).graph;
    %criticalPoints = (clusterPoints(bottleneckVerteces,:));
    %graph = computeGraph(clusterPoints, criticalPoints);
    
    %clusterPoints = [clusterPoints; criticalPoints];
end

%%% HAMILTONIAN PATH
% Ora è tutto pronto per computare il cammino Hamiltoniano

s = findPositionInsideCluster(source, clusterPoints);
d = findPositionInsideCluster(destination, clusterPoints);

P = hamiltonianPath(graph, s, d);
if strcmp(P, 'No Path Found')
    error('HAMILTON: no path found!')
end

path = [];
for i = 1 : length(P)
    path = [path; clusterPoints(P(i),:)];
end

end

%%
% Let us create the following graph
%       (1)--(2)--(3)-------(4)
%        |   / \   |		 |
%        |  /   \  |		 |
%        | /     \ |		 |
%       (5)-------(6)		 |
%		 |		 			 |
%		 |					 |
%		 |					 |
%		(7)-----------------(8)
%   
% G = [0 1 0 0 1 0 0 0;
%      1 0 1 0 1 1 0 0;
%      0 1 0 1 0 1 0 0;
%      0 0 1 0 0 0 0 1;
%      1 1 0 0 0 1 1 0;
%	   0 1 1 0 1 0 0 0;
%	   0 0 0 0 1 0 0 1;
%	   0 0 0 1 0 0 1 0]
% s = 5; % Source
% d = 1; % Destination
%
% P = hamiltonianPath(G,s,d);
%
% P will be an array mentioning the path/cycle, if path/cycle found; or a
% string: 'No Path Found', if path/cycle not found
%
% #Note: This code can be used for finding Hamiltonian cycle also. For
% that, make sure Source and Destination are same.

%%
%{
    Main Function
%}
function hamPath = hamiltonianPath(Graph, Source, Destination)

% Input Checking
if ~isreal(Graph)
    error('Graph must be in real form');
elseif ~isnumeric(Graph)
    error('Matrix must be numeric');
elseif ~ismatrix(Graph)
    error('Check Matrix Dimensions');
else
    [r, c] = size (Graph);
    if r~=c
        error('Matrix must be square matrix');
    end
end

if ~(isreal(Source)||isreal(Destination)||(Source>0 && Source<=r) || (Destination>0 && Destination<=r))
    error('improper Source/Destination');
end

clear c;

% Function call
hamPath = findHam(Graph, Source, Destination, r);

end

%%
%{
    This functions sets some initial parameters, and calls the actual
    function.
%}
function hamPath = findHam(Graph, Source, Destination, totalNodes)

hamPath = zeros(size(Graph(1,:)));

hamPath(1) = Source;

[Status, hamPath] = hamRec(Graph, hamPath, Source, Destination, totalNodes, 1);

if Status == 0
    if Source ~= Destination
        hamPath = 'No Path Found';
    else
        hamPath = 'No Cycle Found';
    end
    return;
end

end

%%
%{
    This function recursively call itself, hence finding the solution
%}
function [Status, hamPath] = hamRec(Graph, hamPath, Source, Destination, totalNodes, nodesFound)

% Ending Condition check
if ( (nodesFound == totalNodes-1 && Source~=Destination) || (nodesFound == totalNodes && Source==Destination) )
    if ( Graph(hamPath(nodesFound), Destination) ~= 0)
        hamPath(nodesFound+1) = Destination;
        Status = 1;
        return;
    else
        Status = 0;
        return;
    end
end

for i=1:totalNodes
    if i==Destination
        continue;
    end
    
    if isSafe(Graph, hamPath, nodesFound, i)
        hamPath(nodesFound+1) = i;
        
        [Status, hamPath] = hamRec(Graph, hamPath, Source, Destination, totalNodes, nodesFound+1);
        if Status
            return;
        end
        
        hamPath(nodesFound+1) = 0;
    end
end

Status = 0;

end

%%
%{
    This function is used to check whether the current node can be added
    or not for making the path/cycle.
%}
function Flag = isSafe(Graph, hamPath, nodesFound, i)

if Graph(hamPath(nodesFound),i) == 0
    Flag = 0;
    return;
end

for ii=1:nodesFound
    if hamPath(ii) == i
        Flag = 0;
        return;
    end
end

Flag = 1;

end



