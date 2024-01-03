function  images_sr_3D = img_sr_imgen(img_interpolant, XYZ_q, ROIs_q, roi_ids, t_last, coordsRconst)
%%
%======> This is a work in progress.
%
%======> img_sr_interpolant:
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
% Developed by MK on 2021_11_20
% Last rev by MK on 2021_12_02
%
%======> This is a work in progress.
%%
tic
st = dbstack;

%%
%======

images_sr_3D=cell(1,length(t_last));


X_cell=XYZ_q.X;
Y_cell=XYZ_q.Y;
Z_cell=XYZ_q.Z;

xcsize = size(X_cell,1);
img_dim = [size(X_cell{1,1}), xcsize];



if length(X_cell)== 1 || coordsRconst
    disp(['"', st.name,'" is calculating const. coords.']);
    X_q = cell2arr_1D(X_cell(:,1));
    Y_q  = cell2arr_1D(Y_cell(:,1));
    Z_q  = cell2arr_1D(Z_cell(:,1));


    for roi_id = roi_ids

        temp_roi = ROIs_q(roi_id, :);
        temp_interpolant = img_interpolant(roi_id, :);

        for tt=1:t_last

            images_sr_3D{tt}(temp_roi{tt}) = temp_interpolant{tt}(X_q(temp_roi{tt}), Y_q(temp_roi{tt}), Z_q(temp_roi{tt}));
           
        end
        clear temp_interpolant temp_ROIs_q temp_pval_q roi temp_roi
    end
    clear X_q Y_q Z_q
    for tt=1:t_last
        images_sr_3D{1,tt} = fillmissing(reshape(images_sr_3D{1,tt},img_dim),'linear');

    end

else
    disp(['"', st.name,'"  is calculating time varying. coords.']);
    for roi_id = roi_ids

        temp_roi = ROIs_q(roi_id, :);
        temp_interpolant = img_interpolant(roi_id, :);
        for tt=1:t_last %timestep_last
            %          {'ROI', tt}

            %==> SA & LA coords
            X_q = cell2arr_1D(X_cell(:,tt));
            Y_q = cell2arr_1D(Y_cell(:,tt));
            Z_q = cell2arr_1D(Z_cell(:,tt));

            images_sr_3D{tt}(temp_roi{tt}) = temp_interpolant{tt}(X_q(temp_roi{tt}),Y_q(temp_roi{tt}),Z_q(temp_roi{tt}));
        end
        
    end

    for tt=1:t_last
        images_sr_3D{1,tt} = fillmissing(reshape(images_sr_3D{1,tt},img_dim),'linear');
    end
end
toc

%%
end
%%
%===
function img_sr = loopover(img_interpolant, X_q, Y_q, Z_q, img_dim, ROIs_q, roi_ids, tt, method)

pval_q = nan(numel(X_q),1);

for roi_id = roi_ids
    pval_q(ROIs_q{roi_id,tt})=img_interpolant{roi_id,tt}(X_q(ROIs_q{roi_id,tt}),Y_q(ROIs_q{roi_id,tt}),Z_q(ROIs_q{roi_id,tt}));
end

img_sr = fillmissing(reshape(squeeze(pval_q),img_dim),method);%reshape(squeeze(pval_q),size(X_q));%
%     {'img_sr -- finished', tt}
end