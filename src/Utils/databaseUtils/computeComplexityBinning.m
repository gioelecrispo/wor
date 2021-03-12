function [counts, Id] = computeComplexityBinning()

SigComp2009 = load('./Results/Data/resultStatistics_SigComp2009__ALL_Ideal.mat');
SigComp2009 = SigComp2009.resultsIdeal;
SVCTask2 = load('./Results/Data/resultStatistics_SVCTask2__ALL_Ideal.mat');
SVCTask2 = SVCTask2.resultsIdeal;
Visual = load('./Results/Data/resultStatistics_Visual__ALL_Ideal.mat');
Visual = Visual.resultsIdeal;

signatures = [SigComp2009.ESTNC, SVCTask2.ESTNC, Visual.ESTNC];

numSignatures = length(signatures);
complexity = zeros(1, numSignatures);
for i = 1 : numSignatures
    complexity(i) = signatures(i).complexity;
end


nbin = 3; 
thresholds = quantile(complexity, nbin-1);
edges = [0; thresholds(:); max(complexity)+0.1];
[counts, Id] = histc(complexity, edges);
counts = counts(1:nbin);

end
