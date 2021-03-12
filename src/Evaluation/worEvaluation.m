function results = worEvaluation(image, clusters, unfolder, data, options)

logger = getLogger(options);
logger.info('** Result evaluation and drawing **');

if options.computeResults
    if strcmpi(options.version, 'ALL')
        options.version = 'ESTNC';
        % - Process evalutation and results
        results.ESTNC = evaluateResults(image, clusters, unfolder.ESTNC, data, options);
        % - Drawing unfolded trace, components
        %drawResults(image, clusters, unfolder.ESTNC, data, options, results.ESTNC);
        options.version = 'RSENC';
        % - Process evalutation and results
        results.RSENC = evaluateResults(image, clusters, unfolder.RSENC, data, options);
        % - Drawing unfolded trace, components
        %drawResults(image, clusters, unfolder.RSENC, data, options, results.RSENC);
        options.version = 'RSEOC';
        % - Process evalutation and results
        results.RSEOC = evaluateResults(image, clusters, unfolder.RSEOC, data, options);
        % - Drawing unfolded trace, components
        %drawResults(image, clusters, unfolder.RSEOC, data, options, results.RSEOC);
        options.version = 'ALL';
    else
        % - Process evalutation and results
        results = evaluateResults(image, clusters, unfolder, data, options);
    end
else 
    results = [];
end

if options.saveResults
    resultBasePath = [options.resultpath, '/', options.databasepath, '/', num2str(options.writer)];
    if ~exist(resultBasePath, 'dir')
        mkdir(resultBasePath)
    end
    resultPath = [resultBasePath, '/', num2str(options.signature)];
    save(resultPath, 'results');
end

end