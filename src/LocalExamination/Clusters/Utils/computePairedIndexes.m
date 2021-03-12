function pairedIndexes = computePairedIndexes(numPaths, combinations, externalAnglesDistances, internalAnglesDistances, dijkstraCurvatures, WEIGHTS)

% WEIGHT_EXTERNAL = 0.4;
% WEIGHT_INTERNAL = 0.05;
% WEIGHT_DIJKSTRA = 0.65; 
% 
% externalAnglesDistancesFrom180 = abs(externalAnglesDistances - 180) * WEIGHT_EXTERNAL;
% internalAnglesDistancesFrom180 = abs(internalAnglesDistances - 180) * WEIGHT_INTERNAL;
% dijkstraCurvatures = dijkstraCurvatures * WEIGHT_DIJKSTRA;
% 
% allContributes = externalAnglesDistancesFrom180 + internalAnglesDistancesFrom180 + dijkstraCurvatures;
allContributes = getAllContributes(WEIGHTS, externalAnglesDistances, internalAnglesDistances, dijkstraCurvatures);


pairedIndexes = NaN(numPaths, 2);
for k = 1 : numPaths

%     [minValueExternal, minIndexExternal] = min(abs(externalAnglesDistances - 180));
%     [minValueInternal, minIndexInternal] = min(abs(internalAnglesDistances - 180));
%      
%     if minIndexExternal == minIndexInternal
%         % Se entrambi mi danno la stessa informazione, confermo la scelta
%         minIndex = minIndexExternal;
%     else
%         % Se invece i due contributi mi danno informazioni diverse, studio
%         % le combinazioni e scelgo per la migliore; 
%         % - Prendo l'indice definito da EXT e computo il valore di INT
%         % relativo a quell'indice e lo sommo; 
%         % - Prendo l'indice definito da INT e computo il valore di INT
%         % relativo a quell'indice e lo sommo;
%         % - scelgo il risultato minore.
%         % ESEMPIO: 
%         % - minIndexExternal    = 2  -->  extAngles(2) =  1°
%         % - minIndexInternal    = 4  -->  intAngles(4) =  5°
%         % sono differenti, analizzo le possibili combinazioni:
%         % - otherIndexExternal  = 4  -->  extAngles(4) = 64°
%         % - otherIndexInternal  = 2  -->  intAngles(2) =  7°
%         % Ora sommo in base all'indice:
%         %  index = 2  --> extAngles(2) + intAngles(2) =  8°
%         %  index = 4  --> extAngles(4) + intAngles(4) = 69°
%         % è minore l'indice 2, scelgo quello.
%         otherExternalAngle = angdiffd(externalAnglesDistances(minIndexInternal), 180);
%         otherInternalAngle = angdiffd(internalAnglesDistances(minIndexExternal), 180);
%         externalContribution = minValueExternal + otherInternalAngle;
%         internalContribution = minValueInternal + otherExternalAngle;
%         if externalContribution < internalContribution
%             minIndex = minIndexExternal;
%         else
%             minIndex = minIndexInternal;
%         end
%     end
    
    
    [~, minIndex] = min(allContributes);
    
    
    indexes = combinations(minIndex,:);
    pairedIndexes(k,:) = indexes;
    [lengthCombinations, ~] = size(combinations);
    
    % Aggiorno angleDistances, togliendo le combinazioni di angoli già accoppiate
    alreadyFound = combinations(:,1)==indexes(1) | combinations(:,1)==indexes(2) | combinations(:,2)==indexes(1) | combinations(:,2)==indexes(2);
    mask = true(1, lengthCombinations);
    mask(alreadyFound) = 0;
    %externalAnglesDistances = externalAnglesDistances(mask);
    %internalAnglesDistances = internalAnglesDistances(mask);
    allContributes = allContributes(mask);
    combinations = combinations(mask,:);
end


end