function [pvals_iso, X, Y, Z,  ROIs_resampled, ROIs_resampled_3D] = img_sr_2isometric(pvals, X_cell, Y_cell, Z_cell, resample_ratio, expand,interp_method, t_last, has_contours, file_endo, file_epi, pixel_spacing, crop_dims, flip_contours, cntrs_used, coordsRconst)
%%
%======> This is a work in progress.
%
%======> img_sr_2isometric:
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
% Developed by MK on 2022_01_18
% Last rev. by MK on 2022_01_20
%
%======> This is a work in progress.
%%


st = dbstack;

%%
%======

img_dims = [size(pvals{1,1}), size(pvals,1)];

pvals_resampled_3D = cell(1, t_last);

X_resampled_3D = cell(1, t_last);
Y_resampled_3D = cell(1, t_last);
Z_resampled_3D = cell(1, t_last);

ROIs_resampled_3D = cell(1, t_last);

resample_ratio(3) = sum(cntrs_used)/length(cntrs_used)*resample_ratio(3);

disp(['<======"', st.name,'" ======> started resampling coords & pvals']);

if length(X_cell)==1 || coordsRconst
    disp(['"', st.name,'" is calculating const. coords.']);
    
    [temp_X_resampled_3D, temp_Y_resampled_3D, temp_Z_resampled_3D] = img_process_resample_coords(...
        X_cell(: ,1),...
        Y_cell(: ,1),...
        Z_cell(: ,1), ...
        resample_ratio, ...
        expand);

        [X_resampled_3D{1,:}] = deal(temp_X_resampled_3D);
        [Y_resampled_3D{1,:}] = deal(temp_Y_resampled_3D);
        [Z_resampled_3D{1,:}] = deal(temp_Z_resampled_3D);

    for tt=1:t_last
        
        if ~isempty(pvals)
            temp_img = reshape([pvals{:,tt}],img_dims);
            
            pvals_resampled_3D{1,tt} = img_process_resample(temp_img, ...
                resample_ratio, ...
                expand, ...
                interp_method);
        end
        
    end
else
    disp(['"', st.name,'"  is calculating time varying. coords.']);
    for tt=1:t_last
        
        if ~isempty(pvals)
            temp_img = reshape([pvals{:,tt}],img_dims);
            
            
            pvals_resampled_3D{1,tt} = img_process_resample(temp_img, ...
                resample_ratio, ...
                expand, ...
                interp_method);
        end
        
        [X_resampled_3D{1,tt}, Y_resampled_3D{1,tt}, Z_resampled_3D{1,tt}] = ...
            img_process_resample_coords(...
            X_cell(: ,tt),...
            Y_cell(: ,tt),...
            Z_cell(: ,tt), ...
            resample_ratio, ...
            expand);
    
    end
end
%%
%======== Contours: 
%======== 
%%
%======== Convert the contours to binary images
% ===>IMPORTANT: check if the images were taken upside down, if so, you
% have to flip the contours
disp(['<======"', st.name,'" ======> started contours']);
coords_dims_resampled = size(X_resampled_3D{1,1});%[size(images_iso{1,1}), size(images_iso,1)];
if has_contours
    temp_ROIs = contour_2_image(file_endo, file_epi,...
        coords_dims_resampled,...
        pixel_spacing,...
        crop_dims, ...
        resample_ratio,...
        cntrs_used);
    
    if flip_contours
        for tt = 1:t_last
            ROIs_resampled_3D{1,tt} = flip(temp_ROIs{tt},3);     
        end
    else
        ROIs_resampled_3D = temp_ROIs;
    end
end

%%
%========  Convert to cell
%========  
%%


pvals_iso = cell(size(X_resampled_3D, 3), t_last);

ROIs_resampled = cell(size(X_resampled_3D,3), t_last);

X = cell(size(X_resampled_3D,3), t_last);
Y = cell(size(Y_resampled_3D,3), t_last);
Z = cell(size(Z_resampled_3D,3), t_last);

for tt=1:t_last
    for kk = 1:1:size(pvals_resampled_3D{1,tt},3)
        
        if ~isempty(pvals)
            pvals_iso{kk,tt} = pvals_resampled_3D{1,tt}(:,:,kk);
        end
        
        X{kk,tt} = X_resampled_3D{1,tt}(:,:,kk);
        Y{kk,tt} = Y_resampled_3D{1,tt}(:,:,kk);
        Z{kk,tt} = Z_resampled_3D{1,tt}(:,:,kk);
        if has_contours
            ROIs_resampled{kk,tt} = ROIs_resampled_3D{1,tt}(:,:,kk);
        else
            ROIs_resampled{kk,tt} =[];
        end
    end
end

%%

end