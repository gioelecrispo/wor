function [] = copyMatFilesFromDB()
% TODO DELETE

basepath = 'C:\Users\joecr\Dropbox\Tesi Magistrale\1. Software\Codice\Database\';
outputpath = 'C:\Users\joecr\Desktop\RecoveredData\';
databases = {'SigComp2009'; 'Visual'; 'SVCTask2'};

for database = 1 : length(databases)
    
    fprintf('- Start database: %s \n', databases{database});
    db = [basepath databases{database} '\'];
    ddb = dir(db); 
    outputdb = [outputpath databases{database} '\'];
    mkdir(outputdb);
    for ii = 1 : length(ddb)-2
        
        fol = ddb(ii+2).name;
        outputfol = [outputpath databases{database} '\' fol];
        mkdir(outputfol);
        dfol_thin = dir([db fol '/*thin__recovered.mat']);
        dfol_skel = dir([db fol '/*skel__recovered.mat']);
        
        for jj = 1 : length(dfol_thin)
            fprintf('%s\n', [fol '\' dfol_thin(jj).name])
            fprintf('%s\n', [fol '\' dfol_skel(jj).name])
            thinFile = [db fol '\' dfol_thin(jj).name];
            skelFile = [db fol '\' dfol_skel(jj).name];
            outputThinFile = [outputfol '\' dfol_thin(jj).name];
            outputSkelFile = [outputfol '\' dfol_skel(jj).name];
            copyfile(thinFile, outputThinFile);
            copyfile(skelFile, outputSkelFile);
        end
        fprintf('- End writer: %d \n', ii);
    end
end
