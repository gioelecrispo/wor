function [errorsDb] = checkEqualitySkelThin()

basepath = 'C:\Users\joecr\Dropbox\Tesi Magistrale\1. Software\Codice\Database\';
databases = {'SigComp2009'; 'Visual'; 'SVCTask2'};

for database = 1 : length(databases)
    
    fprintf('- Start database: %s \n', databases{database});
    db = [basepath databases{database} '\'];
    ddb = dir(db); 
    for ii = 1 : length(ddb)-2
        fol = ddb(ii+2).name;
        dfol_thin = dir([db fol '/*thin__recovered.mat']);
        dfol_skel = dir([db fol '/*skel__recovered.mat']);
        
        for jj = 1 : length(dfol_thin)
            %fprintf('%s\n', [fol '/' dfol_thin(jj).name])
            %fprintf('%s\n', [fol '/' dfol_skel(jj).name])
            thin = load([db fol '/' dfol_thin(jj).name]);
            skel = load([db fol '/' dfol_skel(jj).name]);

            %%% CHECK EQUALITY
            errorIsDetected = false;
            % IMAGE
            thin_image = thin.savedinfo.image;
            skel_image = skel.savedinfo.image;
            if (isequal(thin_image.bw, skel_image.bw) && ...
                isequal(thin_image.toolMatrix, skel_image.toolMatrix) && ...
                isequal(thin_image.branchPointsMatrix, skel_image.branchPointsMatrix) && ...
                isequal(thin_image.endPoints.points, skel_image.endPoints.points) && ...
                isequal(thin_image.retracingPoints.points, skel_image.retracingPoints.points))
                errorIsDetected = true;
            end 
            % CLUSTERS
            if (length(thin.savedinfo.clusters) == length(skel.savedinfo.clusters))
               for c = 1 : length(thin.savedinfo.clusters)
                   c_thin = thin.savedinfo.clusters(c);
                   c_skel = skel.savedinfo.clusters(c);
                   if (isequal(c_thin.pixels, c_skel.pixels))
                       errorIsDetected = true;
                       continue;
                   end
               end
            end
            % TRAJECTORY
            if (isequal(thin.savedinfo.trajectory.x, skel.savedinfo.trajectory.x) && ...
                isequal(thin.savedinfo.trajectory.y, skel.savedinfo.trajectory.y))
                errorIsDetected = true;
            end
            % FINAL CHECK 
            if (errorIsDetected == true)
                errorsDb{end+1} = [databases{database} '\' fol '\' dfol_thin(jj).name];
                fprintf('%s\n', [databases{database} '\' fol '\' dfol_thin(jj).name])
            end
        end
        fprintf('- End writer: %d \n', ii);
    end
end
