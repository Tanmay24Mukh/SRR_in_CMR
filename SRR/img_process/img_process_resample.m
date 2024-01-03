function img_q = img_process_resample(img, ratio, expand, interp_methods)
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
% Developed by MK on 2020_12_06
% Last rev by MK on 2021_12_04
%
%======> This is a work in progress.
%%
F = griddedInterpolant(double(img));

F.Method=interp_methods{1};

if(size(img,3)>1)
    
    [sx,sy,sz] = size(img);
    xq = (0.5+ratio(1)/2-expand(1,1):ratio(1):sx+0.5-ratio(1)/2)+expand(1,2)';
    yq = (0.5+ratio(2)/2-expand(2,1):ratio(2):sy+0.5-ratio(2)/2)+expand(2,2)';
    zq = (0.5+ratio(3)/2-expand(3,1):ratio(3):sz+0.5-ratio(3)/2)+expand(3,2)';
    img_q = F({xq,yq,zq});
    %img_q = uint8(F({xq,yq,zq}));
else
    [sx,sy] = size(img);
    xq = (1:ratio(1):sx)';
    yq = (1:ratio(2):sy)';
    img_q = F({xq,yq});
    
end
end

