% Analyze results here
function [analyzedResults, config] = exctractResults(results, config)

dbNameResultsIdeal = [config.databaseName '__' config.version '_Ideal__'];
dbNameResultsReal = [config.databaseName '__' config.version '_Real__'];

if strcmpi(config.version, 'ALL')
    config.version = 'ESTNC';
    resultsIdealESTNC = adjustResults(results.ideal, config.version);
    analyzedResults.ideal.ESTNC = analyzeResults(dbNameResultsIdeal, resultsIdealESTNC, config);
    resultsIdealESTNC = adjustResults(results.real, config.version);
    analyzedResults.real.ESTNC = analyzeResults(dbNameResultsReal, resultsRealESTNC, resultOptions);
    config.version = 'RSENC';
    resultsIdealRSENC = adjustResults(results.ideal, config.version);
    analyzedResults.ideal.RSENC = analyzeResults(dbNameResultsIdeal,resultsIdealRSENC, config);
    resultsRealRSENC = adjustResults(results.real, resultsOptions.version);
    analyzedResults.real.RSENC = analyzeResults(dbNameResultsReal, resultsRealRSENC, resultOptions);
    config.version = 'RSEOC';
    resultsIdealRSEOC = adjustResults(results.ideal, config.version);
    analyzedResults.ideal.RSEOC = analyzeResults(dbNameResultsIdeal, resultsIdealRSEOC, config);
    resultsRealRSEOC = adjustResults(results.real, resultsOptions.version);
    analyzedResults.real.RSEOC = analyzeResults(dbNameResultsReal, resultsRealRSEOC, resultOptions);
    config.version = 'ALL';
else
    analyzedResults.ideal = analyzeResults(dbNameResultsIdeal, results.ideal, config);
    analyzedResults.real = analyzeResults(dbNameResultsReal, results.real, config);
end

end