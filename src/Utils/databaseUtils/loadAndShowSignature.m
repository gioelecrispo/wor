function [x_8c, y_8c] = loadAndShowSignature(folder, number, SHOW)
% This function get a signature form the db and shows it.

if nargin > 3
    fprintf('Insert 2 or 3 parameters.\n');
    fprintf('folder: - Parameter 1 is for the database folder (writer).\n');
    fprintf('number: - Parameter 2 is for the specific signature in folder.\n');
    fprintf('SHOW:   - Parameter 3 is a boolean for showing the image.\n');
    fprintf('You case also use 2 parameters, the former for the signature (without specificing folder and number) and the latter for showing the image.\n');    return;
else
    load('Database.mat');
    db = database.dbn;
    ddb = dir(db);  
    if nargin == 2
         sign = database.signatures(folder,:);
         folder = sign(1);
         number = sign(2);
    end 
    fol = ddb(folder+2).name;
    dfol = dir([db fol '/*__8con.mat']);
    fprintf('%s\n',[fol '/' dfol(number).name]);
    load([db fol '/' dfol(number).name]);
    
    y_8c = -y_8c;                     % adjusts y coord
    traj = [x_8c', y_8c'];            % creates trajectory
    
    if (nargin == 2 && number == true) || (nargin == 3 && SHOW == true)
        figure,
        plot(x_8c, y_8c, '.'), axis equal;
        title([ ddb(folder+2).name '/' dfol(number).name ])
    end
end

