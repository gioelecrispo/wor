function [image, clusters] = computeClusterInternalAngles(clusterIndex, image, clusters, options, numPixels)

logger = getLogger(options);

%%% Getting cluster information
pixels = clusters(clusterIndex).pixels;
falseTracePoints = clusters(clusterIndex).falseTracePoints;
clusterPoints = [pixels; falseTracePoints];
anchorBP = clusters(clusterIndex).anchorBP;
exitDirections = clusters(clusterIndex).exitDirections;
clusterRank = clusters(clusterIndex).clusterRank; 

internalAngles = zeros(1, clusterRank);

%%% CALCULATION OF THE CENTER OF THE CLUSTER
% The cluster center is a representative point of the cluster, which can
% be used instead of the cluster, inheriting its characteristics.
% Corresponds in practice to the geometric center of gravity.
clusterCenter = [mean(anchorBP(:,1)), mean(anchorBP(:,2))];
logger.debug('Cluster center: [%d %d]', clusterCenter(1), clusterCenter(2));

%%% CALCULATION INTERNAL CORNERS FROM 0 °
% First of all we need to get the vectors of the subsequent pixels to start
% from the anchorBP, then with atan2d_norm all the angles are calculated and with
% the circular average is obtained the value for each anchorBP.
% VECTORS FROM THE CENTER OF THE CLUSTER
% I get the following numPixels px starting from the anchorBP and
% calculating the vectors starting from clusterCenter.
internalAnglesFrom0 = zeros(1, clusterRank);
for i = 1 : clusterRank
    anchorPx = anchorBP(i,:);
    exitDirection = exitDirections(i,:);
    starter = anchorPx + exitDirection;
    [~, unfoldedArray, ~] = traceFollowing_local(image, clusters, options, starter, exitDirection, numPixels);
    %unfoldedArray(unfoldedArray(:,1) == 0 | unfoldedArray(:,2) == 0,:) = [];
    setPoints = [anchorPx; unfoldedArray];
    [lengthSetPoints, ~] = size(setPoints);
    vect = zeros(lengthSetPoints, 2);
    for j = 1 : lengthSetPoints
         vect(j,:) = clusterCenter - setPoints(j,:);
    end
    [lengthVect, ~] = size(vect);
    angles = zeros(1, lengthVect);
    for k = 1 : lengthVect
         angles(k) = atan2d_norm(vect(k,2), vect(k,1));
    end
    weightedArray = weightFunction(lengthVect);
    internalAnglesFrom0(i) = circularMean(angles, weightedArray);
end


vect = zeros(clusterRank, 2);
for i = 1 : clusterRank
    vect(i,:) = clusterCenter - anchorBP(i,:);
end

if clusterRank == 2
    % Since there are only 2 corners, there is no need to calculate
	% their adjacency (they are all close together).
    adiacency = [1 2; 2 1];
elseif clusterRank == 3 
    % Since there are only 2 corners, there is no need to calculate
	% their adjacency (they are all close together).
    adiacency = [1 2; 1 3; 2 3];
else
    %%% CALCULATION ADJACENT POINTS
    % The calculation is done as follows: given a vertex, starting from
	% its internal angle with respect to the abscissa axis, ie from 0 °, yes
	% calculates the difference with the other angles. What you get is
	% the angular difference calculated clockwise. To understand who
	% are the neighbors, so it is sufficient to take the associated indexes
	% respectively to the minor difference and to the major difference, ie to the
	% point closer and farther.
    adiacency = zeros(clusterRank, 2);
    adiacencyCounter = 1;
    for i = 1 : clusterRank
        angleDifferences = NaN(1, clusterRank);
        for j = 1 : clusterRank
            if i ~= j
                angleDiff = mod(internalAnglesFrom0(i) - internalAnglesFrom0(j), 360);
                angleDifferences(j) = angleDiff;
            end
        end
        [~, indexMin] = min(angleDifferences);
        [~, indexMax] = max(angleDifferences); 
        adiacency(adiacencyCounter,:) = [i indexMin];
        adiacencyCounter = adiacencyCounter + 1;
        adiacency(adiacencyCounter,:) = [i indexMax];
        adiacencyCounter = adiacencyCounter + 1;
    end
    [~, idx] = unique(sort(adiacency,2), 'rows', 'stable');
    adiacency = adiacency(idx,:);   
end



%%% CALCULATION INTERNAL CORNERS IN THE CENTER
% Thanks to the information given by the concept of adjacency, we can
% extract the angles in the middle from the vector
% possibleInternalAngles, which holds information of all
% combinations of possible angles in the center.
[lengthAdiacency, ~] = size(adiacency);
[~, order] = sort(internalAnglesFrom0);
sortedAdiacency = adiacency(order,:);
sortedInternalAngles = zeros(1, clusterRank);
for i = 1 : lengthAdiacency
    j = sortedAdiacency(i,1);
    k = sortedAdiacency(i,2);
    if (j == order(1) && k == order(end)) || (j == order(end) && k == order(1))
        sortedInternalAngles(i) = 360 - abs(internalAnglesFrom0(j) - internalAnglesFrom0(k)); 
    else
        sortedInternalAngles(i) = abs(internalAnglesFrom0(j) - internalAnglesFrom0(k)); 
    end
end
cnt = 1;
for i = order
    internalAngles(i) = sortedInternalAngles(cnt);
    cnt = cnt + 1;
end



%%% Updating cluster information
clusters(clusterIndex).adiacency = adiacency;
clusters(clusterIndex).internalAngles = internalAngles;
clusters(clusterIndex).internalAnglesFrom0 = internalAnglesFrom0;
    
end
