%% m_rmse
% La funzione calcola il valore RMSE date in input:
%  - xe: i valori x della traiettoria recovered
%  - ye: i valori y della traiettoria recovered
%  -  x: i valori x della traiettoria reale (8-conn)
%  -  y: i valori y della traiettoria reale (8-conn)function RMSEonDB()
function [RMSE, DTW, DTW_2, SNR] = db_measures(dbName)

dbName = '../Database/Visual/';

ddb = dir(dbName);

%%% OTTIENI DATI DAL DB
x = [];
y = [];
xe = [];
ye = [];
for ii = 1 : length(ddb)-2
    fol = ddb(ii+2).name;
    dfol_online = dir([dbName fol '/*__online.mat']);
    dfol_8conn = dir([dbName fol '/*__8conn.mat']);
    dfol_recovered = dir([dbName fol '/*__thin__recovered.mat']);
    for jj = 1 : length(dfol_8conn)
        clear online online8conn recovered
        fprintf('%s\n',[fol '/' dfol_online(jj).name])
        fprintf('%s\n',[fol '/' dfol_8conn(jj).name])
        fprintf('%s\n',[fol '/' dfol_recovered(jj).name])
        
        online = load([dbName '/' fol '/' dfol_online(jj).name]);
        online8conn = load([dbName '/' fol '/' dfol_8conn(jj).name]);
        recovered = load([dbName '/' fol '/' dfol_recovered(jj).name]);
        
        
        %%% ONLINE SENZA PEN UPs
        penUpIndexes = online.p == 0;
        online.p(penUpIndexes) = [];
        if length(penUpIndexes) ~= length(online.x)
            penUpIndexes = penUpIndexes(1:length(online.x));
        end
        online.x(penUpIndexes) = [];
        online.y(penUpIndexes) = [];
        
        %%% ONLINE 8 CONNESSA SENZA PEN UPs
        zeroIndexes = online8conn.x_8c == 0;
        online8conn.x_8c(zeroIndexes) = [];
        online8conn.y_8c(zeroIndexes) = [];
        online8conn.ep_8c(zeroIndexes) = [];
        
        signatureLength = length(online.x);
        
        %%% NORMALIZZAZIONE COORDINATE
        % Coordinate recovered (mie coordinate)
        [recovered_norm.x, recovered_norm.y] = normalizacionCoordenadas(recovered.savedinfo.trajectory.x, recovered.savedinfo.trajectory.y, signatureLength);
        % Coordinate reale (traiettoria 8-conn derivante dai dati online)
        [online8conn_norm.x, online8conn_norm.y] = normalizacionCoordenadas(online8conn.x_8c, online8conn.y_8c, signatureLength);
        
        x = [x, online8conn_norm.x];
        y = [y, online8conn_norm.y];
        xe = [xe, recovered_norm.x];
        ye = [ye, recovered_norm.y];
    end
end

%%% COMPUTA RMSE
RMSE = m_rmse_ICDAR2013(xe, ye, x, y);
%%% COMPUTA DTW
[C, ~, ~] = m_dtw(pdist2([xe, ye], [x, y], 'euclidean'));
DTW = C(end,end);
DTW_2 = m_dtw_ICDAR2013(xe, ye, x, y);
%%% COMPUTA SNR
SNR = m_SNR(xe, ye, x, y);

% con la x e la y sia reale che recupata viene construita una matrice 
% delle distance euclidee e viene poi ottimizzata in modo elastico il con DTW 
end