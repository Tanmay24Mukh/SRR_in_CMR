function [handle_ax, img_plot_surf] = img_plot_RCS_3D(images, tt, img_idx2plot,handle_ax, cmap,alpha)
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
% Developed by MK on 2021_11_03
% Last rev by MK on 2021_12_14
%
%======> This is a work in progress.
%%

for kk = img_idx2plot

    tangentV_rows = images.info{kk,tt}.ImageOrientationPatient(1:3)';
    tangentV_col = images.info{kk,tt}.ImageOrientationPatient(4:6)';

    dist_r = double(images.info{kk,tt}.Rows*images.info{kk,tt}.PixelSpacing(1));
    dist_c = double(images.info{kk,tt}.Columns*images.info{kk,tt}.PixelSpacing(2));
    
    corner{kk,tt}(1,:) = images.info{kk,tt}.ImagePositionPatient;
    corner{kk,tt}(2,:) = corner{kk,tt}(1,:) + dist_r*tangentV_rows;
    corner{kk,tt}(3,:) = corner{kk,tt}(2,:) + dist_c*tangentV_col;
    corner{kk,tt}(4,:) = corner{kk,tt}(1,:) + dist_c*tangentV_col;

    %     corner{kk,tt}(5,:)=corner{kk,tt}(1,:);
    %     plot3(corner{kk,tt}(:,1),corner{kk,tt}(:,2),corner{kk,tt}(:,3),'-');
    
    img_plot_1=images.pvals.raw{kk,tt};
    xImage = [corner{kk,tt}(1,1) corner{kk,tt}(2,1) ; corner{kk,tt}(4,1) corner{kk,tt}(3,1)];   % The x data for the image corners
    yImage = [corner{kk,tt}(1,2) corner{kk,tt}(2,2) ; corner{kk,tt}(4,2) corner{kk,tt}(3,2)];   % The y data for the image corners
    zImage = [corner{kk,tt}(1,3) corner{kk,tt}(2,3) ; corner{kk,tt}(4,3) corner{kk,tt}(3,3)];   % The z data for the image corners
    
    
    img_plot_surf{kk,tt}=img_plot_as_surface(handle_ax, img_plot_1, xImage, yImage, zImage, cmap, alpha);
end

end