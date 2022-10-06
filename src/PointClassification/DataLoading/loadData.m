function [data, options] = loadData(options, imagepath)

if ~exist('imagepath', 'var')
    path = retrieveSignaturePath([options.imagebasepath '/' options.databasepath], options.writer, options.signature);
else
    path.signaturename = 'default';
    path.thinpath = imagepath;
    path.skelpath = imagepath;
    
end
    
% - Logging initialization
options.loggerOptions.name = path.signaturename;
logger = createLogger(options.loggerOptions);
options.logger = logger;
logger.info('*** START ELABORATION ***');
logger.info('** Data Loading and Initialization **');
logger.info('--> Reading Image and Loading Data...');

% - Image reading and data loading
data.bwideal = readAndBinarizeImage(path.thinpath); 
data.bwreal = readAndBinarizeImage(path.skelpath); 
try
    data.online = load(path.onlinepath);
    data.online8conn = load(path.online8connpath);
catch Exception
    logger.debug('Online data not found');
end


if strcmp(path.signaturename, 'default') ~= 1
    logger.info('Signature Name: %s', [path.databasename '/' path.signaturename]);
    logger.debug('Database: %s, writer; %d, signature: %d', path.databasename, options.writer, options.signature);
else
    logger.info('Loaded Image from: %s', imagepath);
end



end