function img_q=img_process_resample(img,ratio)

% returns a uint8
F = griddedInterpolant(double(img));
F.Method='cubic';
if(size(img,3)>1)
    
    [sx,sy,sz] = size(img);
    xq = (1:ratio(1):sx)';
    yq = (1:ratio(2):sy)';
    zq = (1:ratio(3):sz)';
    img_q = F({xq,yq,zq});
    %img_q = uint8(F({xq,yq,zq}));
else
    [sx,sy] = size(img);
    xq = (1:ratio(1):sx)';
    yq = (1:ratio(2):sy)';
    img_q = F({xq,yq});
    
end

a = 1;
end