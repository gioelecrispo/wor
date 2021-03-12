function result = processEvaluation(online, online8conn, recovered, image, clusters, options)
% La funzione processEvaluation valuta la bontà di ricostruzione della
% traiettoria recovered, ricostruita, in relazione a quella reale, ottenuta
% dall'interpolazione 8-connessa dei dati online.

logger = getLogger(options);

online_withPenUps = online;
online8conn_withPenUps = online8conn;
[online, online8conn] = removePenUps(online_withPenUps, online8conn_withPenUps);

signatureLength = length(online.x);

%%% NORMALIZZAZIONE COORDINATE
% Coordinate recovered (mie coordinate)
[recovered_norm.x, recovered_norm.y] = normalizeCoordinates(recovered.x, recovered.y, signatureLength);
% Coordinate reale (traiettoria 8-conn derivante dai dati online)
[online8conn_norm.x, online8conn_norm.y] = normalizeCoordinates(online8conn.x_8c, online8conn.y_8c, signatureLength);



%%% VALUTAZIONE
% RMSE
% Confronto effettuato tra la recovered e la online 8-conn normalizzate
result.rmse = m_rmse(recovered_norm.x, recovered_norm.y, online8conn_norm.x, online8conn_norm.y);
logger.info('RMSE: %f', result.rmse);

% DTW
% Confronto effettuato tra la recovered e la online 8-conn normalizzate
[C, ~, ~] = m_dtw(pdist2([recovered_norm.x, recovered_norm.y], [online8conn_norm.x, online8conn_norm.y], 'euclidean'));
result.dtw = C(end,end);
logger.info('DTW: %f', result.dtw);

% SNR
% Confronto effettuato tra la recovered e la online 8-conn NON normalizzate
%result.snr = SNRt_1(recovered.x, recovered.y, online8conn.x_8c, online8conn.y_8c);
result.snr = m_SNR(recovered_norm.x, recovered_norm.y, online8conn_norm.x, online8conn_norm.y);
logger.info('SNR: %f', result.snr);


% RESOLVED CLUSTER PERCENTAGE
[result.rcp, result.statistics] = clusterResolutionMeasure(image, clusters, options, online8conn);
logger.info('RCP: %f', result.rcp);

% COMPLESSITA' 
result.complexity = evaluateSignatureComplexity(image, clusters, options);
logger.info('Complexity: %f', result.complexity);

% NUM_COMPONENTI
result.numComponents = evaluateComponentsNumber(image, options, online8conn_withPenUps); 
logger.info('Real components: %d; Estimated components: %d.', result.numComponents(1), result.numComponents(2));

% RECOVERED TRAJECTORY
result.recovered.trajectory = [recovered.x, recovered.y];




end