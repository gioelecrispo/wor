%% QUEUE
classdef DirectionsQueue < handle
    properties
        maxSize
        container
    end
    methods
        function obj = DirectionsQueue(size)
            obj.maxSize = size;
            obj.container = [];
        end
        function obj = add(obj, element)
            if (length(obj.container) < obj.maxSize) && (length(element) == 2) && (isnumeric(element(1)) && isnumeric(element(2)))
                obj.container = [element; obj.container];
            else
                obj.container = [element; obj.container(1:end-1,:)];
            end
        end
        function bool = isEmpty(obj)
            bool = isempty(obj.container);
        end
        function element = front(obj)
            element = obj.container(1,:); 
        end
        function obj = removeNoDirections(obj)
            [lengthContainer, ~] = size(obj.container);
            indexes = true(lengthContainer, 1);
            for i = 1 : lengthContainer
                 if isTheSameDirection(obj.container(i,:), Directions.NO_DIRECTION)
                     indexes(i) = 0;
                 end
            end
            obj.container(indexes==0,:) = [];
        end
        function angle = computeAngle(obj)
            obj = removeNoDirections(obj);
            [lengthContainer, ~] = size(obj.container);
            angles = zeros(1, lengthContainer);
            for i = 1 : lengthContainer
                angles(i) = obtainAngleFromDirection(obj.container(i,:));
            end
            angle = circularMean(angles);
        end
        function angle = computeAngleMultiscale(obj)
            % Inizializzazione
            obj = removeNoDirections(obj);
            [lengthContainer, ~] = size(obj.container);
            cont = obj.container(end:-1:1,:);  % lo giro per comodità
            anglesMultiscale = zeros(lengthContainer, lengthContainer);
            
            % Inizializzazione
            pixels = zeros(lengthContainer, 2);
            anchorBP = [0 0]; % valore a caso - l'algoritmo prescinde dal valore usato
            newPixel = anchorBP;
            % definisco i nuovi pixel a partire dal punto di ancoraggio
            for i = 1 : lengthContainer
                pixels(i,:) = newPixel + cont(i,:); 
                newPixel = pixels(i,:);
            end
            % Ciclo su tutte le scale 
            for j = 1 : lengthContainer
               if j == 1
                   % SCALA 1
                   for i = 1 : j : lengthContainer  
                        anglesMultiscale(1,i) = obtainAngleFromDirection(cont(i,:));
                   end
               else
                   cnt = 1;
                   nextPixel = anchorBP;
                   for i = j : j : lengthContainer
                       dist = nextPixel - pixels(i,:);
                       angleIntermediate(cnt) = atan2d_norm(dist(2), dist(1));
                       nextPixel = pixels(i,:);
                       cnt = cnt + 1;
                   end
                   minAngle = min(angleIntermediate);
                   maxAngle = max(angleIntermediate);
                   passo = -((minAngle - maxAngle)/(lengthContainer-1));
                   if passo ~= 0
                       anglesMultiscale(j,:) = minAngle : passo : maxAngle;
                   else
                       anglesMultiscale(j,:) = minAngle;
                   end
               end
            end
           
            % MULTISCALE MATRIX
            resultMultiscale = zeros(1, lengthContainer);
            for i = 1 : lengthContainer
                resultMultiscale(i) = circularMean(anglesMultiscale(:,i));
            end
            angle = circularMean(resultMultiscale);
            %anglesMultiscale %TODO togliere
            %resultMultiscale %TODO togliere
            %angle            %TODO togliere
        end 
    end
end
