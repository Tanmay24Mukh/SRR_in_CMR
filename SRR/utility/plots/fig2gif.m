function handles = fig2gif(handles, t_max, filename, gifprop)
%%
%======> This is a work in progress.
%
%======> fig2gif:
%
%           INPUTS:
%                   handles
%                   t_max
%                   filename
%                   gifprop
%
%           OUTPUTS:
%                   img_indexed
%                   cmap
%
%
%
%
%======
% Developed by MK on 2021_12_13
% Last rev by MK on 2022_01_23
%
%======> This is a work in progress.
%%
t_max = min(t_max, size(handles,2));


frame=cell(t_max);
figim=cell(t_max);
img_indexed=cell(t_max);
cmap=cell(t_max);


for tt=1:t_max
    frame{tt} = getframe(handles{tt}.figure);
    figim{tt} = frame2im(frame{tt});
    
    [handles{tt}.img_indexed,handles{tt}.cmap] = rgb2ind(figim{tt},gifprop.q_count);
    % Write to the GIF File
    if tt == 1
        imwrite(handles{tt}.img_indexed,handles{tt}.cmap, [filename  '_t' num2str(t_max,'%02.f') '.gif'],'gif', 'Loopcount',gifprop.Loopcount,'DelayTime',gifprop.DelayTime);
    else
        imwrite(handles{tt}.img_indexed,handles{tt}.cmap, [filename  '_t' num2str(t_max,'%02.f') '.gif'],'gif','WriteMode','append','DelayTime',gifprop.DelayTime);
    end
end