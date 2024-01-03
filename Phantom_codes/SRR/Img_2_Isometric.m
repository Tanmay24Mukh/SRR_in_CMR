function [pvals_iso, X, Y, Z] = Img_2_Isometric(pvals, X_cell, Y_cell, Z_cell, resample_ratio, expand,interp_method, t_last, cntrs_used, coordsRconst)


st = dbstack;

%%
%======

img_dims = [size(pvals{1,1}), size(pvals,1)];

pvals_resampled_3D = cell(1, t_last);

X_resampled_3D = cell(1, t_last);
Y_resampled_3D = cell(1, t_last);
Z_resampled_3D = cell(1, t_last);


% resample_ratio(3) = sum(cntrs_used)/length(cntrs_used)*resample_ratio(3);

disp(['<======"', st.name,'" ======> started resampling coords & pvals']);

if length(X_cell)==1 || coordsRconst
    disp(['"', st.name,'" is calculating const. coords.']);
    
    [temp_X_resampled_3D, temp_Y_resampled_3D, temp_Z_resampled_3D] = Img_Process_Resample_Coords(...
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
            
            pvals_resampled_3D{1,tt} = Img_Process_Resample(temp_img, ...
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
            
            
            pvals_resampled_3D{1,tt} = Img_Process_Resample(temp_img, ...
                resample_ratio, ...
                expand, ...
                interp_method);
        end
        
        [X_resampled_3D{1,tt}, Y_resampled_3D{1,tt}, Z_resampled_3D{1,tt}] = ...
            Img_Process_Resample_Coords(...
            X_cell(: ,tt),...
            Y_cell(: ,tt),...
            Z_cell(: ,tt), ...
            resample_ratio, ...
            expand);
    
    end
end

%%
%========  Convert to cell
%========  
%%

pvals_iso = cell(size(X_resampled_3D, 3), t_last);

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

    end
end

%%

end