%% OPTIONS INITIALIZATION
% - Algorithm thresholds and weights initialization
clearvars -except thresholds weights
restoredefaultpath
addpath(genpath('./'))
clc;

%%% Inizialize weights and thresholds
% "weigths" represents the weighs used in the cluster branches association
% weighted approach. 
% See the paper attached to understand better the contributions. 
% If you want to use the default values, just put weights = [];
options.weights = [1 0 0;    % GENERAL (EVEN-RANK and others)
                   1 0 0;    % T-PATTERN / RETRACING
                   1 0 0;    % MARRIED
                   1 0 0];   % ODD-RANK
% "thresholds" represents the thresholds used in the cluster classification
% process.
% See the paper attached to understand better the contributions. 
% If you want to use the default values, just put thresholds = [];
options.thresholds = [  30;     % RETRACING MAX ANGLE WIDENESS 0 - 100
                        25;     % RETRACING MAX SEGMENT LENGTH 0 - 100
                        25;     % RETRACING MAX SEGMENT CURVATURE 0 - 100
                         4;     % T-PATTERN DELTA MAX ANGLE 0 - 100
                        20;     % T-PATTERN OTHER ANGLE WIDENESS 0 - 100 
                        10;     % T-PATTERN ENDPOINT CLUSTER NEARNESS +3,1 -3,1 pixels
                        50;     % MARRIED MAX SEGMENT LENGTH  pixels  +10,5 -10,5 pixels 
                        50;     % MARRIED MAX GOOD CONTINUITY DEGREE  0 - 180 -20,10 +20,10
                        20;     % ODD-RANK MAX SEGMENT LENGTH pixels 20% of the image
                         7;     % PIXELS BRANCH LENGTH pixels +3,1 -3,1
                        12;     % PIXELS BROTHERHOOD pixels +3,1 -3,1
                        10];    % CURVATURE AROUNDNESS point  6,8,10,12,15

options.thresholds = []; % just use the default values
options.weights = [];    % just use the default values
options.version = 'ESTNC';  % for all possibile version see the configuration.m file


% Additional options
options.plot = true;               % if true, it enables all plots
options.real = false;              % if true, it elaborate also the skeleton. The 'skeletonized' version is needed 
options.computeResults = true;     % if true, it compute result with online. Note that the 'online' version is needed
options.saveResults = true;       % if you want to save the results
options.saveDrawings = true;      % if you want to save also the drawings
options.loglevel = 'ALL';    % As LogLevel, you can choose: ALL; TRACE; DEBUG; INFO; WARNING; ERROR; CRITICAL; OFF
options.debug = true;        % if true, it executes also the debug code
options.cleanAfterExecution = true;   % if true, it cleans environment. Needed for experiments (successive executions in a loop)

% Signature options
options.imagebasepath = '../databases';
options.databaseName = 'SigComp2009';
options.writer = 33;         
options.signature = 12; 


%% WRITING ORDER RECOVERY 
[image, clusters, unfolder, data, results] = wor_results(options);