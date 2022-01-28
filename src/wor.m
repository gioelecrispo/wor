function [x, y, wor_result] = wor(imagepath, doplot)

%% CONFIGURATION AND IMAGE LOADING
options = configuration();
data = loadData(options, imagepath);
%% POINT CLASSIFICATION
% - Image analysis, point classification and cluster detection
[image, clusters] = pointClassification(data, options);
%% LOCAL EXAMINATION
% - Skeleton correction and cluster processing
[image, clusters] = localExamination(image, clusters, options);
%% GLOBAL RECONSTRUCTION
% - Initial point detection and trace following
[x, y, wor_result] = globalReconstruction(image, clusters, data, options);

if exist('doplot', 'var') && doplot == 1 
   drawTrajectory_dynamic(image.bw, x, y)
end

end
