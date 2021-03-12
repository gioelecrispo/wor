function [analyzedResults] = analyzeResults(databaseName, results, config)

savingName = [databaseName '__' config.version];

%%% Getting results data
rcpArray  = cell2mat(retrieveStructureField(results, 'rcp'));
dtwArray  = cell2mat(retrieveStructureField(results, 'dtw'));
rmseArray = cell2mat(retrieveStructureField(results, 'rmse'));
SNRArray  = cell2mat(retrieveStructureField(results, 'snr'));
complexityArray     = cell2mat(retrieveStructureField(results, 'complexity'));
numComponentsArray  = cell2mat(retrieveStructureField(results, 'numComponents'));

%%% Filtering perfect cases
% For some signatures the SNR is infinite: the reconstruction is perfect. Average
% of Inf is Inf, for which values are corrected by giving a high SNR, but not
% too much so as not to unbalance the evaluation: the value chosen is 100.
NaNindexes = (isnan(dtwArray));
rcp_f  = rcpArray;
rcp_f(NaNindexes) = [];
dtw_f  = dtwArray; 
dtw_f(NaNindexes) = [];
rmse_f = rmseArray; 
rmse_f(NaNindexes) = [];
SNR_f  = SNRArray; 
SNR_f(NaNindexes) = [];
infIndexes = (SNR_f == Inf); 
SNR_f(infIndexes) = 100;
complexityArray_f = complexityArray; 
complexityArray_f(NaNindexes) = [];
numComponentsArray_f = numComponentsArray;
numComponentsArray_f(NaNindexes,:) = [];
 


%%% Complexity
divisionPoints = prctile(complexityArray_f(:), [33.3 66.6]);
if config.resultsOptions.showImages
    histogram_complexity(savingName, complexityArray_f, divisionPoints, config.resultsOptions.saveOutput);
end


% Defining complexity classes
LOW = 0;
MEDIUM = 1;
HIGH = 2;
[lengthComplexity, ~] = size(complexityArray_f);
for i = 1 : lengthComplexity
   if complexityArray_f(i) <= divisionPoints(1)
       complexityClass(i,1) = LOW;
   elseif  complexityArray_f(i) <= divisionPoints(2)
       complexityClass(i,1) = MEDIUM;
   else
       complexityClass(i,1) = HIGH;
   end
end
lowIndexes    = find(complexityClass == LOW);
mediumIndexes = find(complexityClass == MEDIUM);
highIndexes   = find(complexityClass == HIGH);
if config.resultsOptions.saveOutput == true
    save(['Results/Data/Complexity/complexityClass_' savingName '.mat'], 'complexityClass');
end
 
%%% NUM_COMPONENTS
numComponentsReal = numComponentsArray_f(:,1);
numComponentsEstimated = numComponentsArray_f(:,2);
% Computing errors on estimating components
errorNumComp = abs(numComponentsReal - numComponentsEstimated);
resNC.perc0 = length(find(errorNumComp == 0))/length(errorNumComp);
resNC.perc1 = length(find(errorNumComp == 1))/length(errorNumComp); 
resNC.percMagg = length(find(errorNumComp > 1))/length(errorNumComp);

if config.resultsOptions.showImages == true
    histogram_numComponents(savingName, numComponentsReal, numComponentsEstimated, config.resultsOptions.saveOutput);
    errorPlot_numComponents(savingName, errorNumComp, config.resultsOptions.saveOutput);
end


%%% Total mean
% Computing total mean
resRCP.mean_rcp = mean(rcp_f);
resDTW.mean_dtw = mean(dtw_f);
resRMSE.mean_rmse = mean(rmse_f);
resSNR.mean_SNR = mean(SNR_f);

%%% Mean for complexity class
% Recomputing means for complexity classes
resDTW.mean_lowDTW     = mean(dtw_f(lowIndexes));
resDTW.mean_mediumDTW  = mean(dtw_f(mediumIndexes));
resDTW.mean_highDTW    = mean(dtw_f(highIndexes));
resRMSE.mean_lowRMSE    = mean(rmse_f(lowIndexes));
resRMSE.mean_mediumRMSE = mean(rmse_f(mediumIndexes));
resRMSE.mean_highRMSE   = mean(rmse_f(highIndexes));
resSNR.mean_lowSNR     = mean(SNR_f(lowIndexes));
resSNR.mean_mediumSNR  = mean(SNR_f(mediumIndexes));
resSNR.mean_highSNR    = mean(SNR_f(highIndexes));


%%% Cluster statistics
clusterStatistics = computeClustersStatisticsFromResults(results);
rankRange = [3 10];
if config.resultsOptions.showImages == true
    bar_clusterNumber(savingName, clusterStatistics, rankRange, config.resultsOptions.saveOutput);
    bar_clusterResolutionPercentages(savingName, clusterStatistics, rankRange, config.resultsOptions.saveOutput);
end


analyzedResults.resRCP = resRCP;
analyzedResults.resRMSE = resRMSE; 
analyzedResults.resDTW = resDTW;
analyzedResults.resSNR = resSNR;
analyzedResults.resNC = resNC;
analyzedResults.complexityClass = complexityClass;
analyzedResults.data = results;


end