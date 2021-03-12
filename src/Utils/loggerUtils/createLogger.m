function logger = createLogger(loggerOptions)

name = loggerOptions.name;
path = [loggerOptions.path '/' name '.log'];
cmdlevel = loggerOptions.cmdLevel;
filelevel = loggerOptions.fileLevel;

% Create directory
separatorIndexes = strfind(path, '/');
newDirPath = path(1:separatorIndexes(end)-1);
if ~(exist(newDirPath, 'dir') == 7)
    mkdir(newDirPath);
end
fid = fopen(path, 'wt');
fclose(fid);


[logger, ~] = logging.getLogger(name);
logger.setFilename(path);

if strcmpi(cmdlevel, 'ALL')
    logger.setCommandWindowLevel(logging.logging.ALL);
elseif strcmpi(cmdlevel, 'TRACE')
    logger.setCommandWindowLevel(logging.logging.TRACE);
elseif strcmpi(cmdlevel, 'DEBUG')
    logger.setCommandWindowLevel(logging.logging.DEBUG);
elseif strcmpi(cmdlevel, 'INFO')
    logger.setCommandWindowLevel(logging.logging.INFO);
elseif strcmpi(cmdlevel, 'WARNING')
    logger.setCommandWindowLevel(logging.logging.WARNING);
elseif strcmpi(cmdlevel, 'ERROR')
    logger.setCommandWindowLevel(logging.logging.ERROR);
elseif strcmpi(cmdlevel, 'CRITICAL')
    logger.setCommandWindowLevel(logging.logging.CRITICAL);
elseif strcmpi(cmdlevel, 'OFF')
    logger.setCommandWindowLevel(logging.logging.OFF);
end

if strcmpi(filelevel, 'ALL')
    logger.setLogLevel(logging.logging.ALL);
elseif strcmpi(filelevel, 'TRACE')
    logger.setLogLevel(logging.logging.TRACE);
elseif strcmpi(filelevel, 'DEBUG')
    logger.setLogLevel(logging.logging.DEBUG);
elseif strcmpi(filelevel, 'INFO')
    logger.setLogLevel(logging.logging.INFO);
elseif strcmpi(filelevel, 'WARNING')
    logger.setLogLevel(logging.logging.WARNING);
elseif strcmpi(filelevel, 'ERROR')
    logger.setLogLevel(logging.logging.ERROR);
elseif strcmpi(filelevel, 'CRITICAL')
    logger.setLogLevel(logging.logging.CRITICAL);
elseif strcmpi(filelevel, 'OFF')
    logger.setLogLevel(logging.logging.OFF);
end




end

