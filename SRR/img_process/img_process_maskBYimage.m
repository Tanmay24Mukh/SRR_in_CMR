function img_masked=img_process_maskBYimage(img,img_mask)
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
% Last rev by MK on 2021_12_04
%
%======> This is a work in progress.
%%
for tt=1:length(img)
    img_masked{tt}=img_mask{tt}.*img{tt};
end
end
