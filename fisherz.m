%% Fisher-Z transformation
% transform correlation (r) values into fisher-z scores
% allows averaging across correlation values
%
% USEAGE:
%        z = fisherz(r)
% INPUTS:
%        r: NxM matrix of correlation values
% OUTPUTS:
%        z: NxM matrix of z tranformed values. Note z will return the same
%        size as r
%
% Patrick Cooper, 2015
% Functional Neuroimaging Laboratory, University of Newcastle
function z = fisherz(r)
orig_dims = size(r);
r=r(:);
z=0.5.*log((1+r)./(1-r));
z=reshape(z,orig_dims);