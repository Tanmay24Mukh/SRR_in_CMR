function args = img_struct_args()
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
% Developed by MK on 2021_12_03
% Last rev by MK on 2021_12_03
%
%======> This is a work in progress.
%%
struct_fields_image = {'pvals', 'info', 'map', 'coords', 'ROI'};

pval_fieldnames = {'raw' ,'gray'};
struct_fields_info = {};
struct_fields_map = {};
struct_fields_coords = {'RCS'};
struct_fields_rcs = {'X', 'Y', 'Z'};
struct_fields_roi = {'LV', 'RV', 'BV'};

args =[struct_fields_image; {...
      [pval_fieldnames],...
      [struct_fields_info],...
      [struct_fields_map],...
      [struct_fields_coords; {struct_fields_rcs}],...
      [struct_fields_roi]...
    }];
%%



end

function field_cell_st = struct_fieldgen(field_id, field_names)

field_cell_st = {field_id, field_names};

end