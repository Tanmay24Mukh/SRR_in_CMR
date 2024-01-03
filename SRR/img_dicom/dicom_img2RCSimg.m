function image_RCS = dicom_img2RCSimg(image, image_info)
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
image_RCS = nan(size(image,1)*size(image,2),4);
idx_counter=1;

for row =1:1:size(image,1)
    for col = 1:1:size(image,2)
        image_RCS(idx_counter,:) = [dicom_pixel_ij2RCS(image_info, col-1, row-1)' , image(row,col)];
        
        idx_counter=idx_counter+1;
    end
end

%%
end