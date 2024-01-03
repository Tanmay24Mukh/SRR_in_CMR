function [pcoords_RCS_X, pcoords_RCS_Y, pcoords_RCS_Z] = dicom_get_pixelRCScoords(image, image_info)
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
% Developed by MK on 2021_11_03
% Last rev by MK on 2021_12_04
%
%======> This is a work in progress.
%%
pcoords_RCS_X = nan(size(image,1),size(image,2));
pcoords_RCS_Y = nan(size(image,1),size(image,2));
pcoords_RCS_Z = nan(size(image,1),size(image,2));

for row =1:1:size(image,1)
    for col = 1:1:size(image,2)
        pixelcoords_RCS = dicom_pixel_ij2RCS(image_info, col-1, row-1)';
        pcoords_RCS_X(row, col)=pixelcoords_RCS(1);
        pcoords_RCS_Y(row, col)=pixelcoords_RCS(2);
        pcoords_RCS_Z(row, col)=pixelcoords_RCS(3);
    end
end

%%
end