function path = retrieveSignaturePath(basepath, writer, signature)
% This function compute and return the path of all the versions of a 
% signature (skel, thin, online, online_8conn). 
% Input:  
%     basepath, directory of the db
%     writer, number of the writer
%     signature number of the signature of the writer selected
% Output: the path containing the folder path for all the versions

db = basepath;
ddb = dir(db); 

try
    fol = ddb(writer + 2).name;
catch Exception
    fol = writer; 
end
    
try 
    donline = dir([db '/' fol '/*__online.mat']);
    donline8conn = dir([db '/' fol '/*__8conn.mat']);
    dthin = dir([db '/' fol '/*__thin.png']);
    dskel = dir([db '/' fol '/*__skel.png']);

    path.onlinepath = [basepath '/' fol '/' donline(signature).name]; 
    path.online8connpath = [basepath '/' fol '/' donline8conn(signature).name]; 
    path.thinpath = [basepath '/' fol '/' dthin(signature).name]; 
    path.skelpath = [basepath '/' fol '/' dskel(signature).name]; 
    
    path.signaturename = [fol '/' dthin(signature).name];
    separatorIndexes = strfind(path.signaturename, '__');
    path.signaturename = path.signaturename(1:separatorIndexes(end)-1);
catch Exception
    path.thinpath = [basepath '/' fol '/' signature]; 
    path.skelpath = [basepath '/' fol '/' signature]; 
    path.signaturename = [fol '/' signature];
end

path.databasename = db;
separatorIndexes = strfind(path.databasename, '/');
path.databasename = path.databasename(separatorIndexes(end)+1:end);


end