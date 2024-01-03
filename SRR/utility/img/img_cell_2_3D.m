function img_3d = img_cell_2_3D(image)
%%
%======> This is a work in progress.
%
%======> :
%
%           INPUTS:
%                   image: cell array of form nx1 where n is the slice
%                   count and each image{ii,1} is a 2D image
%
%
%           OUTPUTS:
%                   image as a 3D matrix
%
%
%
%======
% Developed by MK on 2021_12_13
% Last rev by MK on 2022_01_22
%
%======> This is a work in progress.
%%
img_dim = [size(image{1,1}), size(image,1)];    
img_3d = reshape([image{:,1}], img_dim);
end