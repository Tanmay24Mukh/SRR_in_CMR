function ROIs = points_in_rois(XYZ_cell, XYZ_cell_chull, XYZ_cell_chull_index, img_indexed, roi_ids, t_last, coordsRconst)
%%
%======> This is a work in progress.
%
%======> points_in_rois
%           INPUTS:
%               XYZ_cell: Coords of the points we want to query
%               XYZ_cell_chull: Coords of the ROI points for building the convex hull (chull)
%               XYZ_cell_chull_index: indices of ROI images being used
%       
%       
%       
%       
%       
%           OUTPUTS:
%       
%       
%
%======
% Developed by MK on 2022_01_20
% Last rev by MK on 2022_02_28
%
%=====> This is a work in progress.
%%
tic
st = dbstack;

ROIs = cell(length(roi_ids)+1,t_last);

X_cell = XYZ_cell.X;
Y_cell = XYZ_cell.Y;
Z_cell = XYZ_cell.Z;

X_cell_chull=XYZ_cell_chull.X(XYZ_cell_chull_index,:);
Y_cell_chull=XYZ_cell_chull.Y(XYZ_cell_chull_index,:);
Z_cell_chull=XYZ_cell_chull.Z(XYZ_cell_chull_index,:);


if length(X_cell)==1 || coordsRconst
    disp(['"', st.name,'" is calculating const. coords.']);
    %==> SA & LA coords
    X= cell2arr_1D(X_cell(:,1));
    Y= cell2arr_1D(Y_cell(:,1));
    Z= cell2arr_1D(Z_cell(:,1));
    
    %==> Only SA or LA coords
    X_chull = cell2arr_1D(X_cell_chull(:,1));
    Y_chull = cell2arr_1D(Y_cell_chull(:,1));
    Z_chull = cell2arr_1D(Z_cell_chull(:,1));
     for tt=1:t_last %timestep_last  
         
        ROIs(:,tt) = img_get_points_in_rois(roi_ids,img_indexed{1,tt}, X, Y, Z, X_chull, Y_chull, Z_chull);
    end
else
    disp(['"', st.name,'"  is calculating time varying. coords.']);
    for tt=1:t_last %timestep_last
%         {'ROI', tt}
        
        %==> SA & LA coords
        X = cell2arr_1D(X_cell(:,tt));
        Y = cell2arr_1D(Y_cell(:,tt));
        Z = cell2arr_1D(Z_cell(:,tt));
        
        %==> Only SA or LA coords
        X_chull = cell2arr_1D(X_cell_chull(:,tt));
        Y_chull = cell2arr_1D(Y_cell_chull(:,tt));
        Z_chull = cell2arr_1D(Z_cell_chull(:,tt));
        
        ROIs(:,tt) = img_get_points_in_rois(roi_ids,img_indexed{1,tt}, X, Y, Z, X_chull, Y_chull, Z_chull);
    end
end
toc
% {'Points in ROI finished for all' t_last}
end