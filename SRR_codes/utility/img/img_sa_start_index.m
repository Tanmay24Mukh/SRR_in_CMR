function SA_start=img_sa_start_index(crop_ROI_SR, SA_length)
%%
%======> This is a work in progress.
%
%======> :
%
%           INPUTS:
%
%
%
%           OUTPUTS:
%
%
%
%
%======
% Developed by MK on 2020_12_13
% Last rev by MK on 2021_12_24
%
%======> This is a work in progress.
%%
SA_start=1;

for kk=1:size(crop_ROI_SR,1)-SA_length
    if ~isnan(crop_ROI_SR{kk,1})
        SA_start=SA_start+1;
    end
end
end