function [image, clusters] = createParenthood(clusterIndex, image, clusters, options)

logger = getLogger(options);

%%% Getting cluster information
pixels = clusters(clusterIndex).pixels;
falseTracePoints = clusters(clusterIndex).falseTracePoints;
clusterPoints = [pixels; falseTracePoints];
anchorBP = clusters(clusterIndex).anchorBP;
exitDirections = clusters(clusterIndex).exitDirections;
clusterRank =  clusters(clusterIndex).clusterRank;
graph = clusters(clusterIndex).graph;


%%% OTTENIMENTO FIGLI
% Un cluster di rango dispari maggiore di 3 può essere visto come un
% aggregazione di cluster più semplici.
%
%               |                  |
%             - o -     ==>        o       +       - o -
%              / \                / \
%           AGGREGATED          CHILD_1           CHILD_2
%
% La risoluzione di un cluster aggregato consiste nella risoluzione dei
% suoi figli.
% L'operazione più importante è capire come dividere il cluster nei suoi
% due figli, cioè definire quali anchorBP appartengono al CHILD_1 e quali
% appartengono al CHILD_2.
% Nella scomposizione si ha sempre che:
%  - CHILD_1: un figlio è di rango 3;
%  - CHILD_2: l'altro figlio è di rango pari a  clusterRank - 3.
%%%
% Un cluster di rango dispari pari a 3, non classificato come retracing, o 
% accoppiato con altri cluster di rango 3, o come T-pattern pefetto, può 
% essere visto come un aggregazione di cluster più semplici.
%
%                                   
%             - o -     ==>        o       +       - o -
%                \                  \
%           AGGREGATED          CHILD_1           CHILD_2
%
% La risoluzione di un cluster aggregato consiste nella risoluzione dei
% suoi figli.
% L'operazione più importante è capire come dividere il cluster nei suoi
% due figli, cioè definire quali anchorBP appartengono al CHILD_1 e quali
% appartengono al CHILD_2.
% Nella scomposizione si ha sempre che:
%  - CHILD_1: un figlio è di rango 1;
%  - CHILD_2: l'altro figlio è di rango 2.
%%%

%%% DIVISIONE INDICI ANCHOR BP
%
if isOdd(clusterRank) && clusterRank > 3
    clusterRank_child1 = 3;
    clusterRank_child2 = clusterRank - clusterRank_child1;
    numPaths_child2 = clusterRank_child2/2;
    pairedIndexes_child2 = retrieveGoodContinuityIndexesOddRank(numPaths_child2, clusterIndex, image, clusters, options);
elseif clusterRank == 3
    clusterRank_child1 = 1;
    clusterRank_child2 = clusterRank - clusterRank_child1;
    numPaths_child2 = clusterRank_child2 / 2;
    pairedIndexes_child2 = retrieveGoodContinuityIndexesEvenRank(numPaths_child2, clusterIndex, image, clusters, options);
else
    logger.error('CREATE_PARENTHOOD: clusterRank not recognized.');
    error('CREATE_PARENTHOOD: clusterRank not recognized.');
end

indexes_child2 = unique(pairedIndexes_child2);
indexes_child1 = 1 : clusterRank;
indexes_child1(indexes_child2) = [];

%%% COSTRUISCO I NUOVI CLUSTER
% Ottengo la dimensione struttura clusters, per aggiungere in coda
[~, lengthClusters] = size(clusters);

%%%%% CHILD_1
clusterIndex_c1 = lengthClusters + 1;

%%% CALCOLO ANCHOR BRANCH POINT, EXIT DIRECTIONS, FALSE TRACE POINTS, CLUSTER RANK
anchorBP_child1 = anchorBP(indexes_child1,:);
exitDirections_child1 = exitDirections(indexes_child1,:);
clusters(clusterIndex_c1).pixels = pixels;
clusters(clusterIndex_c1).falseTracePoints = falseTracePoints;
clusters(clusterIndex_c1).anchorBP = anchorBP_child1;
clusters(clusterIndex_c1).exitDirections = exitDirections_child1;
clusters(clusterIndex_c1).clusterRank = clusterRank_child1;

%%% CALCOLO ANGOLI
[image, clusters] = computeClusterInternalAngles(clusterIndex_c1, image, clusters, options, Thresholds.NUM_PIXELS_EXPLORATION);
[image, clusters] = computeClusterExternalAngles(clusterIndex_c1, image, clusters, options, Thresholds.NUM_PIXELS_EXPLORATION);
% clusters(clusterIndex_c1).adiacency = adiacency_child1;
% clusters(clusterIndex_c1).internalAngles = internalAngles_child1;
% clusters(clusterIndex_c1).internalAnglesFrom0 = internalAnglesFrom0_child1;
% clusters(clusterIndex_c1).externalAngles = externalAngles_child1;

%%% CALCOLO MATRICE DI ADIACENZA
clusters(clusterIndex_c1).graph = graph;

%%% COMPUTING CONTRIBUTIONS
[image, clusters] = computeExitBranchesContributions(clusterIndex_c1, image, clusters, options);

%%% INIZIALIZZO RELATIONSHIP E FLAG DI GESTIONE
clusters(clusterIndex_c1).relationship = [];
clusters(clusterIndex_c1).processed = false;
clusters(clusterIndex_c1).delete = false;


%%%%% CHILD_2
clusterIndex_c2 = lengthClusters + 2;


%%% CALCOLO ANCHOR BRANCH POINT, EXIT DIRECTIONS, FALSE TRACE POINTS, CLUSTER RANK
anchorBP_child2 = anchorBP(indexes_child2,:);
exitDirections_child2 = exitDirections(indexes_child2,:);
clusters(clusterIndex_c2).pixels = pixels;
clusters(clusterIndex_c2).falseTracePoints = falseTracePoints;
clusters(clusterIndex_c2).anchorBP = anchorBP_child2;
clusters(clusterIndex_c2).exitDirections = exitDirections_child2;
clusters(clusterIndex_c2).clusterRank = clusterRank_child2;

%%% CALCOLO ANGOLI
[image, clusters] = computeClusterInternalAngles(clusterIndex_c2, image, clusters, options, Thresholds.NUM_PIXELS_EXPLORATION);
[image, clusters] = computeClusterExternalAngles(clusterIndex_c2, image, clusters, options, Thresholds.NUM_PIXELS_EXPLORATION);
% clusters(clusterIndex_c2).adiacency = adiacency_child2;
% clusters(clusterIndex_c2).internalAngles = internalAngles_child2;
% clusters(clusterIndex_c2).internalAnglesFrom0 = internalAnglesFrom0_child2;
% clusters(clusterIndex_c2).externalAngles = externalAngles_child2;

%%% CALCOLO MATRICE DI ADIACENZA
clusters(clusterIndex_c2).graph = graph;

%%% COMPUTING CONTRIBUTIONS
[image, clusters] = computeExitBranchesContributions(clusterIndex_c2, image, clusters, options);

%%% INIZIALIZZO RELATIONSHIP E FLAG DI GESTIONE
clusters(clusterIndex_c2).relationship = [];
clusters(clusterIndex_c2).processed = false;
clusters(clusterIndex_c2).delete = false;


%%% FATHER
parenthood = Parenthood();
parenthood.addChild(clusterIndex_c1, indexes_child1);
parenthood.addChild(clusterIndex_c2, indexes_child2);
clusters(clusterIndex).relationship = parenthood;
clusters(clusterIndex).processed = true;
clusters(clusterIndex).delete = true;


end