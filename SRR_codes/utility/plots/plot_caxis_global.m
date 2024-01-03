function cbar_ticks=plot_caxis_global(D,ticks_Count)
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
% Developed by MK on 2020_12_13
% Last rev by MK on 2020_12_24
%
%======> This is a work in progress.
%%
nn=5;
if(length(size(D{1}))==3)
    for tt=1:length(D)
        mags{tt}=sqrt(D{tt}(:,:,1).^2+D{tt}(:,:,2).^2);
        range(tt,1)=max(mags{tt}(:));
        range(tt,2)=min(mags{tt}(:));
    end
elseif(length(size(D{1}))==4)   
    for tt=1:length(D)
        mags{tt}=sqrt(D{tt}(:,:,:,1).^2+D{tt}(:,:,:,2).^2+D{tt}(:,:,:,3).^2);
        range(tt,1)=max(mags{tt}(:));
        range(tt,2)=min(mags{tt}(:));
    end
end
maxx=max(range(:,1));
minn=min(range(:,2));

cbar_ticks=minn:(maxx-minn)/(nn-1):maxx;
end