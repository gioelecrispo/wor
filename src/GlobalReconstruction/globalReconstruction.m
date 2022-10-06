function [x, y, wor_result] = globalReconstruction(image, clusters, data, options)

logger = getLogger(options);
logger.info('** Global Reconstruction **');
logger.info('options.version=%s.', options.version);

if strcmpi(options.version, 'ALL')
    %clusters = resetClustersData(clusters);
    options.version = 'ESTNC';
    % - Initializing unfolder
    unfolder.ESTNC = initializeUnfolder(image);
    % - Initial Starting Point detection
    unfolder.ESTNC = detectInitialPoint(image, clusters, unfolder.ESTNC, data, options);
    % - Trace Following
    unfolder.ESTNC = doTraceFollowing(image, clusters, unfolder.ESTNC, data, options);
    options.version = 'RSENC';
    %clusters = resetClustersData(clusters);
    % - Initializing unfolder
    unfolder.RSENC = initializeUnfolder(image);
    % - Initial Starting Point detection
    unfolder.RSENC = detectInitialPoint(image, clusters, unfolder.RSENC, data, options);
    % - Trace Following
    unfolder.RSENC = doTraceFollowing(image, clusters, unfolder.RSENC, data, options);
    options.version = 'RSEOC';
    %clusters = resetClustersData(clusters);
    % - Initializing unfolder
    unfolder.RSEOC = initializeUnfolder(image);
    % - Initial Starting Point detection
    unfolder.RSEOC = detectInitialPoint(image, clusters, unfolder.RSEOC, data, options);
    % - Trace Following
    unfolder.RSEOC = doTraceFollowing(image, clusters, unfolder.RSEOC, data, options);
    options.version = 'ALL';
else
    % - Initializing unfolder
    unfolder = initializeUnfolder(image);

    % - Initial Starting Point detection
    unfolder = detectInitialPoint(image, clusters, unfolder, data, options);

    % - Trace Following
    unfolder = doTraceFollowing(image, clusters, unfolder, data, options);
end

x = unfolder.unfoldedArray(:, 1);
y = unfolder.unfoldedArray(:, 2);
wor_result = unfolder;

end