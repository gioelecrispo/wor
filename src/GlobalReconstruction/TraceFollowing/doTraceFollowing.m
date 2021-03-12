function unfolder = doTraceFollowing(image, clusters, unfolder, data, options)

logger = getLogger(options);
logger.info('--> Doing Trace Following...');


% - Trace estimation
if strcmpi(options.version, 'ESTNC') == true
    % ESTNC: Estimed Starting Points Nearest Criteria
    % - Getting the estimated end points
    % The end point are estimated by looking at the image.pointsMatrix.
    logger.info('ESTNC: Estimed Starting Points Nearest Criteria') 
    endPoints = getEndPoints(image);
    tracingCondition = true;
    while tracingCondition
        [unfolder, endingPoint, ~] = traceFollowing_component(image, clusters, options, unfolder);
        [nextStartingPoint, ~] = findNextStarter(image, endPoints, endingPoint, unfolder);
        tracingCondition = ~isempty(nextStartingPoint);
        unfolder.starters = [unfolder.starters; nextStartingPoint];
        unfolder.enders = [unfolder.enders; endingPoint];
    end
elseif strcmpi(options.version, 'RSENC') == true 
    % RSENC: Real Starting/Ending Point Nearest Criteria
    % - Getting the real End Points
    % The end point are obtained from the online8connected reference.
    logger.info('RSENC: Real Starting/Ending Point Nearest Criteria')
    startingPoints = unfolder.componentsEdgePoints.startingPoints;
    endingPoints = unfolder.componentsEdgePoints.endingPoints;
    tracingCondition = true;
    while tracingCondition
        % Selecting starting (A) and ending (B) point for the trace following 
        nextStartingPoint = unfolder.starters(end,:);
        nextEndingPoint = unfolder.enders(end,:);
        % Trace following
        [unfolder, endingPoint, ~] = traceFollowing_fromAToB(image, clusters, options, unfolder, nextStartingPoint, nextEndingPoint);
        % Updating starting and ending point
        [nextStartingPoint, nextStarterIndex] = findNextStarter(image, startingPoints, endingPoint, unfolder);
        if ~isempty(nextStartingPoint) && ~isempty(nextStarterIndex)
            nextEndingPoint = endingPoints(nextStarterIndex,:);
        else
            nextEndingPoint = [];
        end
        tracingCondition = ~isempty(nextStartingPoint);
        unfolder.starters = [unfolder.starters; nextStartingPoint];
        unfolder.enders = [unfolder.enders; nextEndingPoint];
    end
elseif strcmpi(options.version, 'RSEOC') == true
    % RSEOC: Real Starting Point Ordered Criteria
    % - Getting real End Points
    % The end point are obtained from the online8connected reference.
    logger.info('RSEOC: Real Starting Point Ordered Criteria');
    startingPoints = unfolder.componentsEdgePoints.startingPoints;
    endingPoints = unfolder.componentsEdgePoints.endingPoints;
    componentIndex = 1;
    tracingCondition = true;
    while tracingCondition
        % Selecting starting (A) and ending (B) point for the trace following 
        nextStartingPoint = unfolder.starters(end,:);
        nextEndingPoint = unfolder.enders(end,:);
        % Trace Following
        [unfolder, endingPoint, ~] = traceFollowing_fromAToB(image, clusters, options, unfolder, nextStartingPoint, nextEndingPoint);
        % Updating starting and ending point
        [nextStartingPoint, nextEndingPoint, componentIndex] = findNextStartingEndingFromOnline(startingPoints, endingPoints, image, componentIndex);
        tracingCondition = ~isempty(nextStartingPoint) && ~isempty(nextEndingPoint);
        unfolder.starters = [unfolder.starters; nextStartingPoint];
        unfolder.enders = [unfolder.enders; nextEndingPoint]; 
        % the endingPoint could be different from the nextEndingPoint (chosen from the online)
    end
else
    logger.error('Error: options.version=%s is not recognized.', options.version);
    error('Error: options.version is not recognized.');
end


end
