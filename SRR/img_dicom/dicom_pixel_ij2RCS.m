function P_xyz = dicom_pixel_ij2RCS(image_info, idx_col, idx_row)
%%
%	image_info: dicom metadata
%	i: Column index to the image plane. The first column is index 0.
%	j: Row index to the image plane. The first row index is 0.
%
%P_xyz: The coordinates of the voxel (i,j) in the frame's image plane in units of mm.
%
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
% Last rev by MK on 2021_12_04
%
%======> This is a work in progress.
%%
S_xyz = image_info.ImagePositionPatient; %Image Position (Patient) (0020,0032). from the origin of the RCS (mm).
X_xyz = image_info.ImageOrientationPatient(1:3); %The values from the row (X) direction cosine of Image Orientation (Patient) (0020,0037).
Y_xyz = image_info.ImageOrientationPatient(4:6); %The values from the column (Y) direction cosine of Image Orientation (Patient) (0020,0037).

delta_i = image_info.PixelSpacing(2);%Column pixel resolution of Pixel Spacing (0028,0030) in units of mm.
delta_j = image_info.PixelSpacing(1);%Row pixel resolution of Pixel Spacing (0028,0030) in units of mm.

idx_coord=[idx_col, idx_row, 0, 1]'; %-1 to compensate for starting from 0
M = zeros(4,4);
M(1:3, 1) = X_xyz.*delta_i;
M(1:3, 2) = Y_xyz.*delta_j;
M(1:3, 4) = S_xyz';
M(4,4) = 1;
temp = M*idx_coord;
P_xyz = temp(1:3);

end