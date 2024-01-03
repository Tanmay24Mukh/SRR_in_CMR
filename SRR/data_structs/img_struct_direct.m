function images = img_struct_direct(images)
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
image_struct_fields = {"pvals", "coords", "ROI", "info", "map" };

pvals_struct_fields = {"raw" ,"gray"};
coords_struct_fields = {"RCS"};
rcs_struct_fields = {"X", "Y", "Z"};
roi_struct_fields = {"LV", "RV","BV"};

images.pvals.raw={};
images.pvals.gray={};

images.coords.RCS.X={};
images.coords.RCS.Y={};
images.coords.RCS.Z={};

images.ROI.LV={};
images.ROI.RV={};
images.ROI.BV={};


end