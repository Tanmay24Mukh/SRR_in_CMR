function [gray, X, Y, Z] = dicom_gpvals_n_rcscoords(images, t_last)
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

%%
%======
raw = images.pvals.raw;
k_size = size(images.pvals.raw, 1);

info = images.info;
gray = cell(size(raw));
X =  cell(size(raw));
Y  = cell(size(raw));
Z  = cell(size(raw));

for tt=1:t_last
    for kk = 1:k_size

        [X{kk,tt}, Y{kk,tt}, Z{kk,tt}] = dicom_get_pixelRCScoords(raw{kk,tt}, info{kk,tt});



        BS = info{kk,tt}.BitsStored;
        gray{kk,tt} = mat2gray(raw{kk,tt},[0, double(2.^BS-1)]);
    end
end

end

