function cntrs_used = contour_used(img_index, img_index_used, flip_contours)
%%
%======> This is a work in progress.
%
%======> contour_used_index:
%
%           INPUTS:
%                   img_index
%                   img_index_used
%                   flip_contours
%
%
%           OUTPUTS:
%
%
%
%
%======
% Developed by MK on 2022_01_25
% Last rev by MK on 2021_01_25
%
%======> This is a work in progress.
%%
img_count = length(img_index);

img_index_used = img_index_used - img_index(1)+1;

cntrs_used = false(img_count,1);
cntrs_used(img_index_used)=true;

if flip_contours
    cntrs_used=flipud(cntrs_used);


end