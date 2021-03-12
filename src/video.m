%% OPTIONS INITIALIZATION
% - Algorithm thresholds and weights initialization
clearvars -except thresholds weights
restoredefaultpath
addpath(genpath('./'))

writerSignatures = {'SigComp2009', 27, 7; % low
                    'SigComp2009', 47, 5;
                    'SigComp2009', 44, 11;
                    'SVCTask2', 8, 9;
                    'SVCTask2', 7, 9;   
                    'SVCTask2', 1, 1; % medium
                    'SVCTask2', 19, 9;
                    'Visual', 14, 5;
                    'Visual', 26, 5;
                    'Visual', 36, 15;
                    'SigComp2009', 71, 6;
                    'SigComp2009', 21, 5;
                    'SigComp2009', 9, 7;   % high
                    'SigComp2009', 15, 2;
                    'SigComp2009', 77, 1;
                    'SigComp2009', 33, 12;
                    'SigComp2009', 72, 2;
                    'SigComp2009', 57, 12;
                    'SVCTask2', 39,9};

for i = 1 : length(writerSignatures)
    database = char(writerSignatures(i,1));
    writer = cell2mat(writerSignatures(i,2));
    signature = cell2mat(writerSignatures(i,3));
    
    clc;
    config.thresholds = [];
    config.weights = []; 
    config.version = 'RSENC';
    config.debug = true;
    config.plot = false;
    config.real = false;
    config.databaseName = database;
    config.writer = writer;
    config.signature = signature;
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

    %% GETTING AND DRAWING RESULTS
    % - Process evaluation and drawing unfolded trace
    results = worEvaluation(image, clusters, unfolder, data, options);

    %% CLEARING ENVIRONMENT
    % - Clearing data, options, unfolder and so on
    cleanEnvironment(image, data, clusters, unfolder, options)
end