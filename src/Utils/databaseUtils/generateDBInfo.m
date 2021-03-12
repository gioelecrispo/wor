function signaturesDB = generateDBInfo(basepath)
% This function creates a mat file that contains some useful information to
% use during the algorithm.
% Input: basepath of the db
% Output: the mat file with the info saved in the basepath folder

% Blind
% MCYT100
% SigComp2009
% SVCTask1
% SVCTask2
% Visual

basepath_dir = dir(basepath);


signaturesCounter = 1;
for ii = 1 : length(basepath_dir)-2
    fol = basepath_dir(ii+2).name;
    dfol = dir([basepath '/' fol '/*__online.mat']);
    for jj = 1 : length(dfol)
        fprintf('%s\n',[fol '/' dfol(jj).name])
        
        signatures(signaturesCounter, :) = [ii jj];
        names{signaturesCounter} = [num2str(ii) '/' dfol(jj).name(1:end-12)];
        signaturesCounter = signaturesCounter + 1;
    end
end


%%% OUTPUT
signaturesDB.basepath = basepath;
signaturesDB.signatures = signatures;
signaturesDB.names = names;

%%% SAVE RESULTS 
save([basepath '/Database.mat'], 'signaturesDB');

end