classdef WeightedVote < handle
    properties
        %%% WEIGHTED
        % The class defines a matrix of weights for the solution of the 
        % clusters. They are differentiated according to its rank.
        % EXTERNAL_ANGLES / INTERNAL_ANGLES / DIJKSTRA
    end
    methods (Static)
        function val = GENERAL(gcr)
            persistent general;
            if nargin >= 1
                general = gcr;
            end
            val = general;
        end
        function val = T_PATTERN_RETR(tpr)
            persistent t_pattern_retr;
            if nargin >= 1
                t_pattern_retr = tpr;
            end
            val = t_pattern_retr;
        end
        function val = MARRIED(m)
            persistent married;
            if nargin >= 1
                married = m;
            end
            val = married;
        end
        function val = ODD_RANK(oddRank)
            persistent odd_rank;
            if nargin >= 1
                odd_rank = oddRank;
            end
            val = odd_rank;
        end
        function [] = initialize(weights)
            if nargin >= 1 && ~isempty(weights)
                WeightedVote.GENERAL(weights(1,:));
                WeightedVote.T_PATTERN_RETR(weights(2,:));
                WeightedVote.MARRIED(weights(3,:));
                WeightedVote.ODD_RANK(weights(4,:));
            else
                % DEFAULT VALUES
                WeightedVote.GENERAL([0.20   0.05   0.75]);
                WeightedVote.T_PATTERN_RETR([0.95   0.00   0.05]);
                WeightedVote.MARRIED([0.40   0.05   0.55]);
                WeightedVote.ODD_RANK([0.70   0.05   0.25]);
            end
        end
        function w = getWeights()
            w(1,:) = WeightedVote.GENERAL;
            w(2,:) = WeightedVote.T_PATTERN_RETR;
            w(3,:) = WeightedVote.MARRIED;
            w(4,:) = WeightedVote.ODD_RANK; 
        end
        function [boolean, extOn] = getExternalSwitch()
            % if boolean == 0 the external angles are not used, 1 otherwise
            w = WeightedVote.getWeights();
            extOn = w(:,1) ~= 0; 
            boolean = any(extOn);   
        end
        function [boolean, intOn] = getInternalSwitch()
            % if boolean == 0 the internal angles are not used, 1 otherwise
            w = WeightedVote.getWeights();
            intOn = w(:,2) ~= 0; 
            boolean = any(intOn);   
         end
        function [boolean, curvOn] = getCurvatureSwitch() 
            % if boolean == 0 the curvature is not used, 1 otherwise
            w = WeightedVote.getWeights();
            curvOn = w(:,3) ~= 0; 
            boolean = any(curvOn);            
        end
    end
end