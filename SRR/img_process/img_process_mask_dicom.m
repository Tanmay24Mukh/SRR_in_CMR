function [img_masked,in_endo,in_epi]=img_process_mask_dicom(img,contour_inner, contour_outer,mm2pixel,crop_ROI,resample_ratio)
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
% Last rev by MK on 2021_12_04
%
%======> This is a work in progress.
%%
img_dim=size(img);
x=1:1:img_dim(1); %rows are in y direction and columns in the x 
y=1:1:img_dim(2);
%%
%generate the query points
kk=1;
for (ii=x)
    for(jj=y)
        coord_q(kk,1:2)=[ii,jj];
        kk=kk+1;
    end
end
%%
if (isnan(contour_inner(1,1)) | isnan(contour_outer(1,1)))
    img_masked=zeros(img); %nothing will be included
else
contour_endo_t(:,1)=(contour_inner(:,1)/mm2pixel-crop_ROI(1,1))/resample_ratio(1); % transfer/scale coordinates
contour_endo_t(:,2)=(contour_inner(:,2)/mm2pixel-crop_ROI(2,1))/resample_ratio(2);

contour_epi_t(:,1)=(contour_outer(:,1)/mm2pixel-crop_ROI(1,1))/resample_ratio(1);
contour_epi_t(:,2)=(contour_outer(:,2)/mm2pixel-crop_ROI(2,1))/resample_ratio(2);
%%
in_endo = inpolygon(coord_q(:,2),coord_q(:,1),contour_endo_t(:,2),contour_endo_t(:,1));
in_epi=inpolygon(coord_q(:,2),coord_q(:,1),contour_epi_t(:,2),contour_epi_t(:,1));


in_myo= ~in_endo & in_epi; %points that are in myocardium
in_myo_img=reshape(in_myo,img_dim(2),img_dim(1));
% size(in_myo_img)
% size(img)
img_masked=in_myo_img'.*img;
end
%%

