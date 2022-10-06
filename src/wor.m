function [x, y, wor_result] = wor(imagepath, doplot, config)

%% CONFIGURATION AND IMAGE LOADING
if ~exist('config', 'var')
    config.thresholds = [];    % set default
    config.weights = [];       % set default
    config.version = 'ESTNC';  % for all possibile version see the configuration.m file
    config.debug = true;
    config.cleanAfterExecution = true;     
    config.plot = true;
    config.real = false;             % the 'skeletonized' version is needed 
    config.computeResults = true;    % the 'online' version is needed
    config.saveResults = true;       % if you want to save the results
    config.saveDrawings = true;      % if you want to save also the drawings
    config.databaseName = 'examples';
    config.writer = 'high';         
    config.signature = 1; 
end
options = configuration(config);
[data, options] = loadData(options, imagepath);

%% POINT CLASSIFICATION
% - Image analysis, point classification and cluster detection
[image, clusters] = pointClassification(data, options);
%% LOCAL EXAMINATION
% - Skeleton correction and cluster processing
[image, clusters] = localExamination(image, clusters, options);
%% GLOBAL RECONSTRUCTION
% - Initial point detection and trace following
[x, y, wor_result] = globalReconstruction(image, clusters, data, options);

if exist('doplot', 'var') && doplot == 1 
   drawTrajectory_dynamic(image.bw, y, x)
end


end
