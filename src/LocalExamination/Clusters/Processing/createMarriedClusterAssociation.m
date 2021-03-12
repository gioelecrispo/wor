function clusters = createMarriedClusterAssociation(clusterIndex1, clusterIndex2, sharedIndexes, connectedIndexes, clusters)
%%% createBadSkelAssociation
% La funzione prende in input gli ID dei due cluster da associare, e gli
% indici degli AnchorBP su cui si uniscono per creare la corretta
% associazione. Restituisce in output la struttura clusters aggiornata, in
% base all'associazione appena effettuata.

%%% CLUSTER 1
% OTTENIMENTO INFO CLUSTER 1
% Si ottengono i pixels e i falseTracePoints che compongono il cluster e 
% gli anchorBP. Si calcolano con Dijkstra tutti possibili modi di
% attraversamento.
pixels1 = clusters(clusterIndex1).pixels;
falseTracePoints1 = clusters(clusterIndex1).falseTracePoints;
clusterPoints1 = [pixels1; falseTracePoints1];
anchorBP1 = clusters(clusterIndex1).anchorBP;

% CALCOLO PAIRED_INDEXES 1
connectedIndex1 = sharedIndexes(1);
totalIndexes = 1 : 3;
totalIndexes(connectedIndex1) = [];
pairedIndexes1 = [totalIndexes(1), connectedIndex1; totalIndexes(2), connectedIndex1]; 

% CALCOLO PATHS 1
[lengthPairedIndexes1, ~] = size(pairedIndexes1);
paths1 = cell(1, lengthPairedIndexes1);
for i = 1 : lengthPairedIndexes1
    source1 = anchorBP1(pairedIndexes1(i,1),:);
    destination1 = anchorBP1(connectedIndex1,:);
    [paths1{i}, clusters] = retrievePathFromDijkstra(clusterIndex1, clusters, source1, destination1);
end
clusters(clusterIndex1).paths = paths1;
clusters(clusterIndex1).processed = true;



%%% CLUSTER 2
% OTTENIMENTO INFO CLUSTER 2
% Si ottengono i pixels e i falseTracePoints che compongono il cluster e 
% gli anchorBP. Si calcolano con Dijkstra tutti possibili modi di
% attraversamento.
pixels2 = clusters(clusterIndex2).pixels;
falseTracePoints2 = clusters(clusterIndex2).falseTracePoints;
clusterPoints2 = [pixels2; falseTracePoints2];
anchorBP2 = clusters(clusterIndex2).anchorBP;

% CALCOLO PAIRED_INDEXES 2
connectedIndex2 = sharedIndexes(2);
totalIndexes = 1 : 3;
totalIndexes(connectedIndex2) = [];
pairedIndexes2 = [totalIndexes(1), connectedIndex2; totalIndexes(2), connectedIndex2]; 

% CALCOLO PATHS 2
[lengthPairedIndexes2, ~] = size(pairedIndexes2);
paths2 = cell(1, lengthPairedIndexes2);
for i = 1 : lengthPairedIndexes2
    source2 = anchorBP2(pairedIndexes2(i,1),:);
    destination2 = anchorBP2(connectedIndex2,:);
    [paths2{i}, clusters] = retrievePathFromDijkstra(clusterIndex2, clusters, source2, destination2);
end
clusters(clusterIndex2).paths = paths2;
clusters(clusterIndex2).processed = true;


%%% CREAZIONE WEDDING RELATIONSHIP
% 
%
connectedIndexes1 = connectedIndexes;
connectedIndexes2 = connectedIndexes1(:,end:-1:1);
sharedIndexes1 = sharedIndexes;
sharedIndexes2 = sharedIndexes(end:-1:1);
% CLUSTER 1
clusters(clusterIndex1).relationship = Wedding(pairedIndexes1, clusterIndex2, sharedIndexes1, connectedIndexes1, paths1);
% CLUSTER 2
clusters(clusterIndex2).relationship = Wedding(pairedIndexes2, clusterIndex1, sharedIndexes2, connectedIndexes2, paths2);




end