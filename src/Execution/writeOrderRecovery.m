function [image, clusters, unfolder, data, results] = writeOrderRecovery(config)

%% OPTIONS INITIALIZATION
% - Algorithm thresholds and weights initialization
options = configuration(config);

%% DATA LOADING AND INITIALIZATION 
% - Image reading and data loading
[data, options] = loadData(options);

%% POINT CLASSIFICATION
% - Image analysis, point classification and cluster detection
[image, clusters] = pointClassification(data, options);

%% LOCAL EXAMINATION
% - Skeleton correction and cluster processing
[image, clusters] = localExamination(image, clusters, options);

%% GLOBAL RECONSTRUCTION
% - Initial point detection and trace following
unfolder = globalReconstruction(image, clusters, data, options);

%% COMPUTING RESULTS
% - Process evaluation and drawing unfolded trace
results = worEvaluation(image, clusters, unfolder, data, options);

%% DRAWING RESULTS
% - Drawing unfolded trace, components
drawSignatureResults(image, clusters, unfolder, data, options, results);

%% CLEARING ENVIRONMENT
% - Clearing data, options, unfolder and so on
cleanEnvironment(image, data, clusters, unfolder, options);


end