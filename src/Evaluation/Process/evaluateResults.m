function results = evaluateResults(image, clusters, unfolder, data, options)

logger = getLogger(options);
logger.info('--> Results processing...');


recoveredIdeal.x = unfolder.unfoldedArray(:,2);
recoveredIdeal.y = unfolder.unfoldedArray(:,1);
results = processEvaluation(data.online, data.online8conn, recoveredIdeal, image, clusters, options);

end