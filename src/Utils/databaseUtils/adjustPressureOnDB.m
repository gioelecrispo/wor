function adjustPressureOnDB(db)
% This utility function aims to correct the pressure value of the
% signatures. It converts the not-1 values into 0 values.
% Input: the path of the db to adjust
% Output: the db with the pressure adjusted


ddb = dir(db);                   % Original Database directory



%% EXECUTION 
for ii = 1 : length(ddb)-2
    fol = ddb(ii+2).name;
    dfol_8cc = dir([db fol '/*__8conn.mat']);
    for jj = 1 : length(dfol_8cc)
        clear x_8c y_8c ep_8c
        fprintf('%s\n',[fol '/' dfol_8cc(jj).name])
        
        load([db '/' fol '/' dfol_8cc(jj).name]);  
        notOne = find(ep_8c ~= 1);
        ep_8c(notOne) = 0;
        save([db '/' fol '/' dfol_8cc(jj).name], 'x_8c', 'y_8c', 'ep_8c');
    end
    
    fprintf('- End writer: %d \n', ii);
end

    fprintf('--- END ---\n');

end