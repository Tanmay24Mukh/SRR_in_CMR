function contour_resample(img,ratio)
%%
% returns a uint8
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
F = griddedInterpolant(double(img));

[sx,sy,sz] = size(img);
xq = (1:ratio(1):sx)';
yq = (1:ratio(2):sy)';
zq = (1:ratio(3):sz)';
% img_q = F({xq,yq,zq});
img_q = uint8(F({xq,yq,zq}));
end