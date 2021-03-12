function [] = cleanEnvironment(image, data, clusters, unfolder, options)

if options.cleanAfterExecution
    logging.clearLogger(options.loggerOptions.name);
    close all;
end