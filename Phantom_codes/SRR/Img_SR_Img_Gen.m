function  images_sr_3D = Img_SR_Img_Gen(img_interpolant, XYZ_q, roi_ids, t_last, coordsRconst)
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

        % temp_roi = ROIs_q(roi_id, :);
        temp_interpolant = img_interpolant(roi_id, :);

        for tt=1:t_last

            images_sr_3D{tt} = temp_interpolant{tt}(X_q, Y_q, Z_q);
           
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

        % temp_roi = ROIs_q(roi_id, :);
        temp_interpolant = img_interpolant(roi_id, :);
        for tt=1:t_last %timestep_last
            %          {'ROI', tt}

            %==> SA & LA coords
            X_q = cell2arr_1D(X_cell(:,tt));
            Y_q = cell2arr_1D(Y_cell(:,tt));
            Z_q = cell2arr_1D(Z_cell(:,tt));

            images_sr_3D{tt} = temp_interpolant{tt}(X_q,Y_q,Z_q);
        end
        
    end

    for tt=1:t_last
        images_sr_3D{1,tt} = fillmissing(reshape(images_sr_3D{1,tt},img_dim),'linear');
    end
end
toc

%%
end
