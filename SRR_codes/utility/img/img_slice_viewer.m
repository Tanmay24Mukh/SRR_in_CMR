function img_slice_viewer(image_cell,figprop, axprop, pltprop)
%%
%======> This is a work in progress.
%
%======> img_viewer_3D:
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
% Developed by MK on 2022_01_25
% Last rev by MK on 2021_01_25
%
%======> This is a work in progress.
%%
image_arr = cell2arr_3D(image_cell);

set(axprop.parent, 'position', figprop.position);
if pltprop.SliceDirection==[1,0,0]
    image_arr=flipud(permute(image_arr,[3,2,1]));
end
s = sliceViewer(image_arr,...
    'parent', axprop.parent,...
    'Colormap',axprop.ColorMap,...
    'SliceNumber', pltprop.SliceNumber,...
    'SliceDirection', pltprop.SliceDirection,...
    'ScaleFactors',pltprop.ScaleFactors,...
    'DisplayRangeInteraction','on');

addlistener(s,'SliderValueChanging',@allevents);
addlistener(s,'SliderValueChanged',@allevents);

caxis(axprop.clim);

end

function allevents(src,evt)
    evname = evt.EventName;
    switch(evname)
        case{'SliderValueChanging'}
            disp(['Slider value changing event: ' mat2str(evt.CurrentValue)]);
        case{'SliderValueChanged'}
            disp(['Slider value changed event: ' mat2str(evt.CurrentValue)]);
    end
end