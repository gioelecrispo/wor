function [representativeCurv, anglesDirection, selectedPoints] = evaluateCurvatureMultiscale(points, numPoints, aroundness)

% aroundness: il numero di punti da prendere in avanti ed indietro rispetto
%             al selectedPoint corrente.

% ESEMPIO
%
%                ____o_____
%             x_/          \            x è il selectedPoint corrente
%       o ___/              \_o         o sono gli altri selectedPoints
%      |
%     /                                 aroundness specifica il numero di
%    o                                 selectedPoints da prendere prima e
%    |                                 dopo quello corrente per il calcolo
%
%%%%%
[lengthPoints, ~] = size(points);
if numPoints > lengthPoints
    numPoints = lengthPoints;
end
interval = floor(linspace(1, lengthPoints, numPoints));



if lengthPoints < 3
    %%% CURVATURA MEDIA
    % e' dritto
    representativeCurv = 0;
    anglesDirection = [];
    selectedPoints = [];
else
    %%% REGISTRO I NUM_POINTS PUNTI DELLA CURVA
    selectedPoints = zeros(numPoints, 2);
    indexes = [];
    for i = 1 : numPoints
        index = interval(i);
        selectedPoints(i,:) = points(index,:);
        indexes = [indexes, index];
    end
    
    %%% CALCOLO CURVATURA
    [lengthSelectedPoints, ~] = size(selectedPoints);
    anglesDirection = zeros(1, lengthSelectedPoints);
    cstd = zeros(1, aroundness); 
    s = zeros(1, aroundness); 
    for sel = 1 : lengthSelectedPoints
        point = selectedPoints(sel,:);
        
        for arn = 1 : aroundness
            
            angles_forw = [];
            if sel >= 1 && sel <= lengthSelectedPoints - 1
                numAngles_forw = lengthSelectedPoints - sel;
                if numAngles_forw >= arn
                    numAngles_forw = arn;
                end
                vect_forw = zeros(numAngles_forw, 2);
                angles_forw = zeros(1, numAngles_forw);
                for i = 1 : numAngles_forw
                    vect_forw(i,:) = point - selectedPoints(sel+i,:);
                    angles_forw(i) = atan2d_norm(vect_forw(i,2), vect_forw(i,1));
                end
            end
            
            angles_back = [];
            if sel >= 2 && sel <= lengthSelectedPoints
                numAngles_back = sel - 1;
                if numAngles_back >= arn
                    numAngles_back = arn;
                end
                vect_back = zeros(numAngles_back, 2);
                angles_back = zeros(1, numAngles_back);
                for i = 1 : numAngles_back
                    vect_back(i,:) = point - selectedPoints(sel-i,:);
                    angles_back(i) = atan2d_norm(vect_back(i,2), vect_back(i,1)) - 180;
                    if angles_back(i) < 0
                        angles_back(i) = angles_back(i) + 360;
                    end
                end
            end
            
            angles = [angles_forw, angles_back];
            cstd(arn) = circularMean(angles);
        end
        
        anglesDirection(sel) = mean(cstd);
    end
    
    %%% PUNTO DI SALIENZA - CURVATURA RAPPRESENTATIVA
    % Vale per segmenti corti
    anglesDifferences = angdiffd(anglesDirection);
    representativeCurv = max(anglesDifferences);
end


end