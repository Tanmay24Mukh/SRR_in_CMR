function struct_fields_image = img_struct_cells()
%%
%======> This is a work in progress.
%
%======> img_struct_cells:
%
%           INPUTS:
%
%
%
%           OUTPUTS:
%                   struct_fields_image
%
%
%
%======
% Developed by MK on 2021_12_03
% Last rev by MK on 2021_12_04
%
%======> This is a work in progress.
%%
pval_fieldnames = {'raw' ,'gray'};
pval_id= 'pvals';
pval_st = {pval_id; pval_fieldnames};
%%
info_fieldnames = {};
info_id= 'info';
info_st = {info_id; info_fieldnames};
%%
map_fieldnames = {};
map_id= 'map';
map_st = {map_id; map_fieldnames};
%%
rcs_fieldnames = {'X', 'Y', 'Z'};
rcs_id= 'RCS';
rcs_st = {rcs_id; rcs_fieldnames};
%%
coords_fieldnames = rcs_st;
coords_id= 'coords';
coords_st = {coords_id; coords_fieldnames};
%%
roi_fieldnames = {'LV', 'RV', 'BV'};
roi_id= 'ROI';
roi_st = {roi_id; roi_fieldnames};
%%
struct_fields_image = {pval_st , info_st, map_st, coords_st, roi_st};
%%
end