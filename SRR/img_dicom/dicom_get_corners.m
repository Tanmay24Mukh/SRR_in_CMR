function img_corners=dicom_get_corners(image_info)
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
% Developed by MK on 2021_02_03
% Last rev by MK on 2021_12_04
%
%======> This is a work in progress.
%%
cosine_dir_rows=image_info.ImageOrientationPatient(1:3)';
cosine_dir_cols=image_info.ImageOrientationPatient(4:6)';
dim_r=double(image_info.Rows*image_info.PixelSpacing(1));
dim_c=double(image_info.Columns*image_info.PixelSpacing(2));

img_corners(1,:)=image_info.ImagePositionPatient;
img_corners(2,:)=img_corners(1,:)+dim_r*cosine_dir_rows;
img_corners(3,:)=img_corners(2,:)+dim_c*cosine_dir_cols;
img_corners(4,:)=img_corners(1,:)+dim_c*cosine_dir_cols;

end