function images_cr = img_struct_cropper_par(images, crop_ROI, t_last, max_thread)
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
% Developed by MK on 2021_12_13
% Last rev by MK on 2021_12_24
%
%======> This is a work in progress.
%%

k_size = size(images.pvals.raw, 1);

gray = images_o.pvals.gray;
X =  images_o.coords.RCS.X;
Y  = images_o.coords.RCS.Y;
Z  = images_o.coords.RCS.Z;

kk_counter=0;
k_mat=zeros(t_last,2);

for tt=1:t_last
    for kk=1:k_size
        k_mat(tt,1)=kk;
        if ~isnan(crop_ROI{kk,tt})
            kk_counter = kk_counter+1;
            k_mat(tt,2) = kk_counter;
        end
    end
    kk_counter = 0;
end
gray_cr = cell(max(k_mat(:,2), t_last);

parfor (tt=1:t_last, max_thread)
    kk_counter=0;
    for kk=1:k_size
        if  k_mat(tt,2)~=0
            kk_counter = kk_counter+1;
            
            gray_cr{kk_counter,tt} = img_process_crop(gray{kk,tt}, crop_ROI{kk,tt});
            
            X_cr{kk_counter,tt} = img_process_crop(X{kk,tt}, crop_ROI{kk,tt});
            Y_cr{kk_counter,tt} = img_process_crop(Y{kk,tt}, crop_ROI{kk,tt});
            Z_cr{kk_counter,tt} = img_process_crop(Z{kk,tt}, crop_ROI{kk,tt});
        end
    end
    kk_counter = 0;
end
images_cr.pvals.gray = gray_cr;
images_cr.coords.RCS.X = X_cr;
images_cr.coords.RCS.Y = Y_cr;
images_cr.coords.RCS.Z = Z_cr;
end