function img_sr_interpolant = Img_SR_Interpolant(images, XYZ, ROIs_o, roi_ids, interp_method, t_last, coordsRconst)
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
% Developed by MK on 2021_11_18
% Last rev. by MK on 2022_01_20
%
%======> This is a work in progress.
%%
st = dbstack;
%%
%======

method_interp = interp_method{1};
method_exterp = interp_method{2};

% img_sr_interpolant = cell(length(roi_ids),t_last);
img_sr_interpolant = cell(1,t_last);

X_cell = XYZ.X;
Y_cell = XYZ.Y;
Z_cell = XYZ.Z;

if length(X_cell)==1 || coordsRconst
    disp(['"', st.name,'" is calculating const. coords.']);

    X = cell2arr_1D(X_cell(:,1));
    Y = cell2arr_1D(Y_cell(:,1));
    Z = cell2arr_1D(Z_cell(:,1));

    pvals = splitapply(@cell2arr_1D, images,1:size(images,2));
    size(pvals)

    % for roi_id=roi_ids %timestep_last
    %     %         {'ROI', tt}
    %     %==> SA & LA coords
    %
    %     x = cellfun(@(idx) X(idx), ROIs_o(roi_id,:), 'UniformOutput',false);
    %     y = cellfun(@(idx) Y(idx), ROIs_o(roi_id,:), 'UniformOutput',false);
    %     z = cellfun(@(idx) Z(idx), ROIs_o(roi_id,:), 'UniformOutput',false);
    %     for tt=1:t_last
    %         pval{1,tt} = pvals(ROIs_o{roi_id,tt},tt);
    %     end
    for tt=1:t_last

        img_sr_interpolant{1, tt} = loopover(pvals{1,tt}, X{1,tt}, Y{1,tt}, Z{1,tt}, method_interp, method_exterp);

    end



    % end
else
    disp(['"', st.name,'"  is calculating time varying. coords.']);


    pvals = splitapply(@cell2arr_1D, images,1:size(images,2));
    size(pvals)

    % for roi_id=roi_ids %timestep_last
    %         {'ROI', tt}
    %==> SA & LA coords

    for tt=1:t_last
        X = cell2arr_1D(X_cell(:,tt));
        Y = cell2arr_1D(Y_cell(:,tt));
        Z = cell2arr_1D(Z_cell(:,tt));
        x{1,tt} = X;y{1,tt} = Y;z{1,tt} = Z;
        % x = cellfun(@(idx) X(idx), ROIs_o(roi_id,:), 'UniformOutput',false);
        % y = cellfun(@(idx) Y(idx), ROIs_o(roi_id,:), 'UniformOutput',false);
        % z = cellfun(@(idx) Z(idx), ROIs_o(roi_id,:), 'UniformOutput',false);
        pval{1,tt} = pvals(:,tt);
    end
    for tt=1:t_last

        img_sr_interpolant{1, tt} = loopover(pval{1,tt}, x{1,tt}, y{1,tt}, z{1,tt}, method_interp, method_exterp);
        disp(tt)

    end

    % end
end

%%
end
function img_sr_interpolant = loopover(pval,X, Y, Z,method_interp, method_exterp)



img_sr_interpolant = ...
    scatteredInterpolant(X, Y, Z, ...
    pval,...
    method_interp ,...
    method_exterp );

end