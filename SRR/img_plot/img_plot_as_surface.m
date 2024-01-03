function img_plot_surf=img_plot_as_surface(ax,img,xImage,yImage,zImage,cmap,alpha)
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
% Developed by MK on 2020_12_03
% Last rev by MK on 2021_11_24
%
%======> This is a work in progress.
%%

img_plot_surf=surf(ax,xImage,yImage,zImage,...    % Plot the surface
    'CData',img,...
    'FaceColor','texturemap', 'EdgeColor', 'none','FaceAlpha',alpha);
    c_ax=colormap(ax,cmap);
    
end