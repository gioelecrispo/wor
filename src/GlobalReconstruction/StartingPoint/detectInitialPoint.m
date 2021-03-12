function unfolder = detectInitialPoint(image, clusters, unfolder, data, options)

logger = getLogger(options);
logger.info('--> Detecting initial starting point...');


    
if strcmpi(options.version, 'ESTNC') == true || strcmpi(options.version, 'ALL') == true
    % ESTNC: Estimed Starting Points Nearest Criteria
    % - Getting the estimated end points
    % The end point are estimated by looking at the image.pointsMatrix.
    logger.info('ESTNC: Estimed Starting Points Nearest Criteria')
    logger.info('- Getting the estimated End Points')
    startingPoints = getImageEndPoints(image, clusters);
    [numEndPoints, ~] = size(startingPoints);
    if ~isEven(numEndPoints)
        logger.warn('Estimated end point number is not even; probably the writing order recovery will not be satisfactory.')
    end
    logger.info('- Detecting initial starting point through the ellipse statistical method');
    % - Chosing initial Starting Point
    % Local method
    statisticalInitialPoint = retrieveStatisticalStartPoint();
    [starter, ~] = findStartingPoint_local(image, options, startingPoints, statisticalInitialPoint);

    % Global method
    if (isempty(starter))
        logger.warn('No Initial Starting Point have been found through the ellipse statistical method. A global heuristic will be used.');
        logger.info('- Detecting initial starting point through the global heuristic method');
        [starter, ~] = findStartingPoint_global(image, options, startingPoints);
    end
    
    unfolder.starters = starter;
elseif strcmpi(options.version, 'RSENC') == true || strcmpi(options.version, 'ALL') == true
    % RSENC: Real Starting/Ending Point Nearest Criteria
    % - Getting the real End Points
    % The end point are obtained from the online8connected reference.
    logger.info('RSENC: Real Starting/Ending Point Nearest Criteria')
    logger.info('- Getting the real End Points')
    unfolder.componentsEdgePoints.startingPoints = getOnlineStartingPoints(data.online8conn);
    unfolder.componentsEdgePoints.endingPoints = getOnlineEndingPoints(data.online8conn);
    
    if options.plot
        drawOnlineStartingEndingPoints(image, unfolder, options);
    end
    
    startingPoints = unfolder.componentsEdgePoints.startingPoints;
    endingPoints = unfolder.componentsEdgePoints.endingPoints;
    
    % - Chosing initial Starting Point
    % Local method
    statisticalInitialPoint = retrieveStatisticalStartPoint();
    [starter, startingIndex] = findStartingPoint_local(image, options, startingPoints, statisticalInitialPoint);
    
    % Global method
    if (isempty(starter))
        logger.warn('No Initial Starting Point have been found through the ellipse statistical method. A global heuristic will be used.');
        logger.info('- Detecting initial starting point through the global heuristic method');
        [starter, startingIndex] = findStartingPoint_global(image, options, startingPoints);
    end
    ender = endingPoints(startingIndex,:);
    unfolder.starters = starter;
    unfolder.enders = ender;
elseif strcmpi(options.version, 'RSEOC') == true || strcmpi(options.version, 'ALL') == true
    % RSEOC: Real Starting Point Ordered Criteria
    % - Getting real End Points
    % The end point are obtained from the online8connected reference.
    logger.info('RSEOC: Real Starting Point Ordered Criteria');
    logger.info('- Getting the real End Points')
    unfolder.componentsEdgePoints.startingPoints = getOnlineStartingPoints(data.online8conn);
    unfolder.componentsEdgePoints.endingPoints = getOnlineEndingPoints(data.online8conn);
    
    if options.plot
        drawOnlineStartingEndingPoints(image, unfolder, options);
    end
    
    startingPoints = unfolder.componentsEdgePoints.startingPoints;
    endingPoints = unfolder.componentsEdgePoints.endingPoints;

    % Find real first starting/ending points
    unfolder.starters = findFirstPoint(image, startingPoints, options);
    unfolder.enders = findFirstPoint(image, endingPoints, options);
else
    logger.error('Error: options.version=%s is not recognized.', options.version);
    error('Error: options.version is not recognized.');
end




end
