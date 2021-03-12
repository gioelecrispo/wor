function doDBSkeletonization(db)

ddb = dir(db);                   % Original Database directory



%% EXECUTION 
for ii = 1 : length(ddb)-2
    fol = ddb(ii+2).name;
    dfol = dir([db fol '/*__img.png']);
    for jj = 1 : length(dfol)
        fprintf('%s\n',[fol '/' dfol(jj).name])
        
        skeletonize([db fol '/' dfol(jj).name]);           % saves the real skeleton
    end
    
    fprintf('- End writer: %d \n', ii);
end

    fprintf('--- END ---\n');

end