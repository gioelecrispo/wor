function [s, s0] = circularStd(angles)
%%%%%
% Computes circular standard deviation for circular data (equ. 26.20, Zar).   
% 
%  Input:
%      angles    sample of angles in radians
% 
%  Output:
%      s         angular deviation
%      s0        circular standard deviation
% 
%  PHB 6/7/2008
% 
%  References:
%    Biostatistical Analysis, J. H. Zar
% 
%  TAKEN FROM: Circular Statistics Toolbox for Matlab
%%%%%

w = ones(size(angles));
angles = deg2rad(angles);

% compute weighted sum of cos and sin of angles
r = sum(exp(1i*angles));

% obtain length 
r = abs(r)./sum(w);


%%% COMPUTE ANGULAR DEVIATION
s = rad2deg(sqrt(2*(1-r))); 

%%% COMPUTER CIRCULAR STANDARD DEVIATION 
s0 = rad2deg(sqrt(-2*log(r)));