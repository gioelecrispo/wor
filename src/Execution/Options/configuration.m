function options = configuration(config)


%%% Parameters configuration
Thresholds.initialize(config.thresholds);
WeightedVote.initialize(config.weights);

%%% Version options
% We could choose for different versions: 
%  - ESTNC: Estimed Starting Points Nearest Criteria -> we estimate the 
%  components starting points and we choose the next through the Nearest 
%  Criteria (by taking the end point with the minimum distance).
%  - RSENC: Real Starting/Ending Point Nearest Criteria -> we take the
%  starting/ending points location from the real reference (the 8connected 
%  version) and we choose the next through the Nearest Criteria (by taking 
%  the end point with the minimum distance).
%  - RSEOC: Real Starting Point Ordered Criteria -> we take the
%  starting/ending points location from the real reference(the 8connected 
%  version) and we choose the next by looking at the reference (we have an 
%  ordered set of starting points).
%  - ALL: all the previous strategies, together
% 
% ! Even if the RSTOC strategy is the best it does not guarantees the
% perfect wor because we could have troubles in recognizing end points !
options.version = config.version;


%%% Code options
% options.debug: if you want to execute with debug code;
% options.plot: if you want to plot some auxiliar figures;
% options.real: if you want to do the algorithm also on the real signature version (you need a skeletonization specimen) 
% options.computeResults: if you want to compute the metrics (you need the online version of the speciment)
% options.cleanAfterExcution: if you want to clean the environment after the execution;
options.debug = config.debug;
options.plot = config.plot;
options.real = config.real;
options.saveResults = config.saveResults;
options.saveDrawings = config.saveDrawings;
options.computeResults = config.computeResults;
options.cleanAfterExecution = config.cleanAfterExecution;

%%% Path options
options.imagebasepath = '../databases'; 
options.databasepath = config.databaseName;
options.loggerbasepath = ['../results/logs/' options.version];
options.resultpath = ['../results/execution/' options.version];
options.drawpath = ['../results/images/' options.version];

%%% Signature options
options.writer = config.writer;
options.signature = config.signature;

%%% Logger options
% As Level, you can choose: ALL; TRACE; DEBUG; INFO; WARNING; ERROR; CRITICAL; OFF.
loggerOptions.name = '';
loggerOptions.path = [options.loggerbasepath '/' options.databasepath];
loggerOptions.cmdLevel = 'ALL';
loggerOptions.fileLevel = 'ALL';
options.loggerOptions = loggerOptions; 
% options.logger = createLogger(loggerOptions);

end

