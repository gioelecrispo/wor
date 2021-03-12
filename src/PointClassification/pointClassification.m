function [image, clusters] = pointClassification(data, options)

logger = getLogger(options);

logger.info('** Point Classification **');
logger.info('--> Analizing image...');
image.bw = data.bwideal;
image.dimensions = size(image.bw);
image = analyzeImage(image, options);
[image, clusters] = detectCluster(image, options);


end
