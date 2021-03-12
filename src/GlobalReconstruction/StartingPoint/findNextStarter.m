function [starter, nextStarterIndex] = findNextStarter(image, endPoints, finalPoint, unfolder)
% Search for a new starting point (starter) for the next trace
% following. In an image you can have several separate components, e
% therefore more endPoints. The selection criterion is based on proximity
% compared to the last untangled of the previous section.

starter = [];
nextStarterIndex = [];




%%% Filtering the not traced end point
% First we delete the already routed endPoints
if ~isempty(finalPoint)
    [lengthEndPoints, ~] = size(endPoints);
    notTracedEndPoints = nan(lengthEndPoints, 2);
    for nextStarter = 1 : lengthEndPoints
        epx = endPoints(nextStarter,1);
        epy = endPoints(nextStarter,2);
        % If the point has not already been plotted, we add it to notTracedEndPoints
        if unfolder.tracedMatrix(epx, epy) == 0
            notTracedEndPoints(nextStarter,:) = endPoints(nextStarter,:);
        else
            notTracedEndPoints(nextStarter,:) = [NaN, NaN];
        end
    end
    
    %%% Finding next starter
    % If all the endPoints have already been tracked, there is nothing else
    % do, we have untangled everything. An empty starter is then returned
    % and the case managed externally.
    if sum(isnan(notTracedEndPoints(:))) == lengthEndPoints*2 % isempty(notTracedEndPoints)
        starter = [];
        nextStarterIndex = [];
    else
        % select a new starter, taking the nearest one according to the
        % Euclidean distance
        [lengthNotTracedEndPoints, ~] = size(notTracedEndPoints);
        distance = zeros(1, lengthNotTracedEndPoints);
        for nextStarter = 1 : lengthNotTracedEndPoints
            distance(nextStarter) = pdist([notTracedEndPoints(nextStarter,:); finalPoint], 'euclidean');
        end
        [~, nextStarterIndex] = min(distance);
        
        starter = notTracedEndPoints(nextStarterIndex,:);
    end
end

end