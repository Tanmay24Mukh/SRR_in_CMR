function img_cropped=img_process_crop(img,crop_dim)
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

if length(size(img))==3
    img_cropped = img(1+crop_dim(1,1):end-crop_dim(1,2),1+crop_dim(2,1):end-crop_dim(2,2),1+crop_dim(3,1):end-crop_dim(3,2));
elseif length(size(img))== 2
    img_cropped = img(1+crop_dim(1,1):end-crop_dim(1,2),1+crop_dim(2,1):end-crop_dim(2,2));
end
%%

end