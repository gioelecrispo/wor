classdef Thresholds
    properties (Constant)
        %% BAD_SKEL_I_MIN_ANGLE_WIDENESS - pattern I
        % Soglia PERCENTUALE
        % Rappresenta la minima ampiezza che il più grande angolo interno di
        % un cluster di rango 3 deve avere per essere classificato come un
        % errore di skeletonizzazione dovuto a due linee troppo vicine
        % nell'immagine originale.
        % La percentuale è calcolata sull'angolo giro.
        % Il massimo angolo interno deve dunque essere maggiore del SOGLIA%,
        % secondo questa formula:   100*(maxInternalAngle)/360 > SOGLIA
        BAD_SKEL_I_MIN_ANGLE_WIDENESS = 40;
        
        %% BAD_SKEL_I_MIN_SEGMENT_SLANG - pattern I
        % Soglia PERCENTUALE
        % Rappresenta la minima differenza che l'angolo tra i punti di
        % unione di due cluster di rango 3 deve avere per essere classificato
        % come un errore di skeletonizzazione dovuto a due linee troppo
        % vicine nell'immagine originale.
        % In pratica il segmento deve essere più o meno dritto, non curvo.
        % La percentuale è calcolata sull'angolo giro.
        % La differenza angolare deve dunque essere minore del SOGLIA%,
        % secondo questa formula:   100*(|angle1 - angle2|)/360 > SOGLIA
        BAD_SKEL_I_MIN_SEGMENT_SLANG = 45;
        
        %% BAD_SKEL_I_MAX_SEGMENT_LENGTH - pattern I
        % Soglia ASSOLUTA
        % Rappresenta la massima lunghezza che il segmento di unione di due
        % cluster di rango 3 deve avere per essere classificato come un
        % errore di skeletonizzazione dovuto a due linee troppo vicine
        % nell'immagine originale.
        % La soglia è assoluta, non deve dipendere dalla grandezza
        % dell'immagine, ma è un errore della skeletonizzazione dovuta alla
        % vicinanza di due linee nell'immagine originale. Per questo motivo,
        % non può superare una certa soglia limite definita in pixels.
        BAD_SKEL_I_MAX_SEGMENT_LENGTH = 20;   % in px
        
        %% NUM_PIXELS_EXPLORATION_BETTER_PRECISION
        % Soglia ASSOLUTA
        % Rappresenta il numero di pixels da esplorare per ottenere le
        % informazioni sugli angoli esterni di un cluster.
        NUM_PIXELS_EXPLORATION_BETTER_PRECISION = 20;
        
        %% NUM_POINTS_STRAIGHTNESS
        % Soglia ASSOLUTA
        % Rappresenta il numero di punti in cui sezionare un segmento per
        % valutarne la sua rettilineità.
        NUM_POINTS_STRAIGHTNESS = 25;
        
    end
    methods (Static)
        function [] = initialize(values)
            if nargin >= 1 && ~isempty(values)
                Thresholds.RETRACING_MAX_ANGLE_WIDENESS(values(1));
                Thresholds.RETRACING_MAX_SEGMENT_LENGTH(values(2));
                Thresholds.RETRACING_MAX_SEGMENT_CURVATURE(values(3));
                Thresholds.T_PATTERN_DELTA_MAX_ANGLE(values(4));
                Thresholds.T_PATTERN_OTHER_ANGLE_WIDENESS(values(5));
                Thresholds.T_PATTERN_MIN_CLUSTER_ENDPOINT_NEARNESS(values(6));
                Thresholds.MARRIED_MAX_SEGMENT_LENGTH(values(7));
                Thresholds.MARRIED_MAX_GOOD_CONTINUITY_DEGREE(values(8));
                Thresholds.ODD_RANK_MAX_SEGMENT_LENGTH(values(9));
                Thresholds.NUM_PIXELS_EXPLORATION(values(10));
                Thresholds.NUM_PIXELS_BROTHERHOOD(values(11));
                Thresholds.CURVATURE_AROUNDNESS(values(12));
            else
                % DEFAULT VALUES
                Thresholds.RETRACING_MAX_ANGLE_WIDENESS(28);
                Thresholds.RETRACING_MAX_SEGMENT_LENGTH(20);
                Thresholds.RETRACING_MAX_SEGMENT_CURVATURE(20);
                Thresholds.T_PATTERN_DELTA_MAX_ANGLE(3);
                Thresholds.T_PATTERN_OTHER_ANGLE_WIDENESS(19);
                Thresholds.T_PATTERN_MIN_CLUSTER_ENDPOINT_NEARNESS(8);
                Thresholds.MARRIED_MAX_SEGMENT_LENGTH(50);
                Thresholds.MARRIED_MAX_GOOD_CONTINUITY_DEGREE(40);
                Thresholds.ODD_RANK_MAX_SEGMENT_LENGTH(20);
                Thresholds.NUM_PIXELS_EXPLORATION(5);
                Thresholds.NUM_PIXELS_BROTHERHOOD(2*Thresholds.NUM_PIXELS_EXPLORATION);
                Thresholds.CURVATURE_AROUNDNESS(10);
            end
        end
        function thresholds = getThresholds()
            thresholds(1) = Thresholds.RETRACING_MAX_ANGLE_WIDENESS;
            thresholds(2) = Thresholds.RETRACING_MAX_SEGMENT_LENGTH;
            thresholds(3) = Thresholds.RETRACING_MAX_SEGMENT_CURVATURE;
            thresholds(4) = Thresholds.T_PATTERN_DELTA_MAX_ANGLE;
            thresholds(5) = Thresholds.T_PATTERN_OTHER_ANGLE_WIDENESS;
            thresholds(6) = Thresholds.T_PATTERN_MIN_CLUSTER_ENDPOINT_NEARNESS;
            thresholds(7) = Thresholds.MARRIED_MAX_SEGMENT_LENGTH;
            thresholds(8) = Thresholds.MARRIED_MAX_GOOD_CONTINUITY_DEGREE;
            thresholds(9) = Thresholds.ODD_RANK_MAX_SEGMENT_LENGTH;
            thresholds(10) = Thresholds.NUM_PIXELS_EXPLORATION;
            thresholds(11) = Thresholds.NUM_PIXELS_BROTHERHOOD;
            thresholds(12) = Thresholds.CURVATURE_AROUNDNESS;
        end
        function val = RETRACING_MAX_ANGLE_WIDENESS(rmaw)
            %% RETRACING_MAX_ANGLE_WIDENESS - retracing ^
            % Soglia PERCENTUALE
            % La soglia rappresenta la massima ampiezza che l'angolo (opposto
            % ad un ramo connesso con un end-point) di un cluster di rango 3
            % deve avere per essere classificato come un retracing cluster.
            % La differenza deve dunque essere minore del SOGLIA%, secondo questa
            % formula:   100*(|angle1 - angle2|)/360 < SOGLIA
            % RETRACING_MAX_ANGLE_WIDENESS = 28;
            persistent retracingMaxAngleWideness;
            if nargin >= 1
                retracingMaxAngleWideness = rmaw;
            end
            val = retracingMaxAngleWideness;
        end
        function val = RETRACING_MAX_SEGMENT_LENGTH(rmsl)
            %% RETRACING_MAX_SEGMENT_LENGTH - retracing ^
            % Soglia PERCENTUALE
            % Rappresenta la massima lunghezza in pixels che il segmento dritto
            % uscente da un cluster di rango 3 deve avere per essere
            % classificato come un retracing ^ cluster.
            % IE' calcolato in relazione alla dimensioni delle immagine.
            % Il valore deve essere minore della SOGLIA.
            % Il numero di pixels deve dunque essere minore del SOGLIA%,
            % secondo questa formula:  pxCounter < (SOGLIA*maxImageDim)/100
            % RETRACING_MAX_SEGMENT_LENGTH = 20;
            persistent retracingMaxSegmentLength;
            if nargin >= 1
                retracingMaxSegmentLength = rmsl;
            end
            val = retracingMaxSegmentLength;
        end
        function val = RETRACING_MAX_SEGMENT_CURVATURE(rmsc)
            %% RETRACING_MAX_SEGMENT_CURVATURE - retracing ^
            % Soglia ASSOLUTA
            % Rappresenta la massima curvatura che gli angoli del
            % segmento uscente da un cluster di rango 3 deve avere per essere
            % classificato come un retracing ^ cluster.
            % Il valore deve essere minore della SOGLIA.
            % RETRACING_MAX_SEGMENT_CURVATURE = 20;
            persistent retracingMaxSegmentCurvature;
            if nargin >= 1
                retracingMaxSegmentCurvature = rmsc;
            end
            val = retracingMaxSegmentCurvature;
        end
        function val = T_PATTERN_DELTA_MAX_ANGLE(tpdma)
            %% T_PATTERN_DELTA_MAX_ANGLE - pattern T
            % Soglia PERCENTUALE
            % Rappresenta la massima distanza che un angolo interno di un cluster
            % di rango 3 deve avere per essere classificato come un T pattern.
            % La percentuale è calcolata sull'angolo giro.
            % T_PATTERN_DELTA_MAX_ANGLE = 3;
            persistent tPatternDeltaMaxAngle;
            if nargin >= 1
                tPatternDeltaMaxAngle = tpdma;
            end
            val = tPatternDeltaMaxAngle;
        end
        function val = T_PATTERN_OTHER_ANGLE_WIDENESS(tpoaw)
            %% T_PATTERN_OTHER_ANGLE_WIDENESS - pattern T
            % Soglia PERCENTUALE
            % Rappresenta la minima ampiezza che gli altri angoli interni di un
            % cluster di rango 3 devono avere per essere classificato come un
            % T pattern.
            % La percentuale è calcolata sull'angolo giro.
            % L'ampiezza deve dunque essere maggiore del SOGLIA%, secondo questa
            % formula:   100*(angle)/360 > SOGLIA
            % T_PATTERN_OTHER_ANGLE_WIDENESS = 19;       % 70 gradi
            persistent tPatternOtherAngleWideness;
            if nargin >= 1
                tPatternOtherAngleWideness = tpoaw;
            end
            val = tPatternOtherAngleWideness;
        end
        function val = T_PATTERN_MIN_CLUSTER_ENDPOINT_NEARNESS(tpmcen)
            %% T_PATTERN_MIN_CLUSTER_ENDPOINT_NEARNESS - pattern T
            % Soglia ASSOLUTA
            % Rappresenta la minima distanza che il cluster in esame deve avere
            % da un altro cluster di rango 3 e da un END POINT per essere
            % classificato come un  T pattern.
            % La soglia è assoluta e valutata in termini di pixels (dipende dalla
            % risoluzione dell'immagine, potrebbe dover essere modificata).
            % Dunque, se un cluster di rango 3 non è distante da un altro di
            % rango 3 almeno T_PATTERN_MIN_CLUSTER_NEARNESS px allora non viene
            % trattato come un T pattern.
            % T_PATTERN_MIN_CLUSTER_ENDPOINT_NEARNESS = 8;     % in px
            persistent tPatternMinClusterEndPointNearness;
            if nargin >= 1
                tPatternMinClusterEndPointNearness = tpmcen;
            end
            val = tPatternMinClusterEndPointNearness;
        end
        function val = MARRIED_MAX_SEGMENT_LENGTH(mmsl)
            %% MARRIED_MAX_SEGMENT_LENGTH - pattern >--<
            % Soglia PERCENTUALE
            % Rappresenta la massima lunghezza che il segmento che unisce due
            % cluster di rango 3 deve avere per essere classificati come
            % possibili married clusters >--<. Il valore in pixels deve essere
            % minore della SOGLIA.
            % MARRIED_MAX_SEGMENT_LENGTH = 50;
            persistent marriedMaxSegmentLength;
            if nargin >= 1
                marriedMaxSegmentLength = mmsl;
            end
            val = marriedMaxSegmentLength;
        end
        function val = MARRIED_MAX_GOOD_CONTINUITY_DEGREE(mmgcd)
            %% MARRIED_MAX_GOOD_CONTINUITY_DEGREE - pattern >--<
            % Soglia ASSOLUTA
            % Rappresenta il massimo valore di grado di buona continuità che due
            % cluster di rango 3 devono avere per essere classificati come
            % married.
            % Il massimo grado di buona continuità deve essere minore della
            % SOGLIA, secondo questa formula:   gcr < SOGLIA
            % MARRIED_MAX_GOOD_CONTINUITY_DEGREE = 40;
            persistent marriedMaxGoodContinuityDegree;
            if nargin >= 1
                marriedMaxGoodContinuityDegree = mmgcd;
            end
            val = marriedMaxGoodContinuityDegree;
        end
        function val = ODD_RANK_MAX_SEGMENT_LENGTH(odmsl)
            %% ODD_RANK_MAX_SEGMENT_LENGTH - odd rank clusters
            % Soglia PERCENTUALE
            % Rappresenta la massima lunghezza che il segmento che collega
            % un cluster di rango dispari > 3 deve avere per capire se è
            % vicino o meno ad un cluster di rank 3 con il quale può unirsi
            % od a un end point con il quale costituire un retracing. Il
            % valore deve essere minore della SOGLIA.
            % ODD_RANK_MAX_SEGMENT_LENGTH = 20;
            persistent oddRankMaxSegmentLength;
            if nargin >= 1
                oddRankMaxSegmentLength = odmsl;
            end
            val = oddRankMaxSegmentLength;
        end
        function val = NUM_PIXELS_EXPLORATION(npe)
            %% NUM_PIXELS_EXPLORATION
            % Soglia ASSOLUTA
            % Rappresenta il numero di pixels da esplorare per ottenere le
            % informazioni sugli angoli esterni di un cluster.
            % NUM_PIXELS_EXPLORATION = 5;
            persistent numPixelsExploration;
            if nargin >= 1
                numPixelsExploration = npe;
            end
            val = numPixelsExploration;
        end
        function val = NUM_PIXELS_BROTHERHOOD(npb)
            %% NUM_PIXELS_BROTHERHOOD
            % Soglia ASSOLUTA
            % Rappresenta il numero di pixels massimo per cui unire due cluster
            % in una brotherhood. E' un valore che dipende dalla risoluzione
            % dell'immagine.
            % NUM_PIXELS_BROTHERHOOD = 2*Thresholds.NUM_PIXELS_EXPLORATION;
            persistent numPixelsBrotherhood;
            if nargin >= 1
                numPixelsBrotherhood = npb;
            end
            val = numPixelsBrotherhood;
        end
        function val = CURVATURE_AROUNDNESS(ca)
            %% CURVATURE_AROUNDNESS
            % Soglia ASSOLUTA
            % Indica l'intorno in punti di interesse (selectedPoints) da
            % controllare a destra e a sinistra del punto di interesse per
            % ottenere il suo valore di curvatura.
            % CURVATURE_AROUNDNESS = 100;
            persistent curvatureAroundness;
            if nargin >= 1
                curvatureAroundness = ca;
            end
            val = curvatureAroundness;
        end
    end
end