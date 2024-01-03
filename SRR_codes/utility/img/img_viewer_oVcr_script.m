%%
%======> This is a work in progress.
%
%======> img_viewer_oVcr_script:
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
tt=1;
sa_index=images_cr.props.SA.index;
la_index=images_cr.props.LA.index;

%%

figindex.figs=1;
figindex.axes=1;
figindex.plts=1;

handles.figs{figindex.figs}=figure();

figprop.figs{figindex.figs,1}.position = [60, 200, 300, 300];
figprop.axes{figindex.figs,1}.parent = handles.figs{figindex.figs};

figprop.axes{figindex.figs,1}.ColorMap = gray(1024);
figprop.axes{figindex.figs,1}.clim=[0 1];
figprop.plts{figindex.figs,1}.SliceDirection=[0,0,1];
figprop.plts{figindex.figs,1}.SliceNumber=1;
figprop.plts{figindex.figs,1}.ScaleFactors =[1,1,1];

img_slice_viewer(images_o.pvals.gray(sa_index,tt), figprop.figs{figindex.figs,1}, figprop.axes{figindex.figs,1}, figprop.plts{figindex.figs,1})
set(handles.figs{figindex.figs},'Position',figprop.figs{figindex.figs,1}.position);
%%

figindex.figs=figindex.figs+1;
figindex.axes=figindex.axes+1;
figindex.plts=figindex.plts+1;

handles.figs{figindex.figs}=figure();

figprop.figs{figindex.figs,1}.position = figprop.figs{figindex.figs-1,1}.position+[figprop.figs{figindex.figs-1,1}.position(3), 0, 0, 0];
figprop.axes{figindex.figs,1}.ColorMap = gray(1024);
figprop.axes{figindex.figs,1}.parent = handles.figs{figindex.figs};
figprop.plts{figindex.figs,1}.SliceDirection=[1,0,0];
figprop.plts{figindex.figs,1}.SliceNumber=1;
figprop.plts{figindex.figs,1}.ScaleFactors =[1,5,1];
figprop.axes{figindex.figs,1}.clim=[0 1];


img_slice_viewer(images_o.pvals.gray(la_index,tt), figprop.figs{figindex.figs,1}, figprop.axes{figindex.figs,1}, figprop.plts{figindex.figs,1})
set(handles.figs{figindex.figs},'Position',figprop.figs{figindex.figs,1}.position);
%%

figindex.figs=figindex.figs+1;
figindex.axes=figindex.axes+1;
figindex.plts=figindex.plts+1;

handles.figs{figindex.figs}=figure();

figprop.figs{figindex.figs,1}.position = figprop.figs{figindex.figs-1,1}.position+[figprop.figs{figindex.figs-1,1}.position(3), 0, 0, 0];
figprop.axes{figindex.figs,1}.ColorMap = gray(1024);
figprop.axes{figindex.figs,1}.parent = handles.figs{figindex.figs};
figprop.plts{figindex.figs,1}.SliceDirection=[0,0,1];
figprop.plts{figindex.figs,1}.SliceNumber=1;
figprop.plts{figindex.figs,1}.ScaleFactors =[1,1,1];
figprop.axes{figindex.figs,1}.clim=[0 1];


img_slice_viewer(images_cr.pvals.gray(sa_index,tt), figprop.figs{figindex.figs,1}, figprop.axes{figindex.figs,1}, figprop.plts{figindex.figs,1})
set(handles.figs{figindex.figs},'Position',figprop.figs{figindex.figs,1}.position);
%%

figindex.figs=figindex.figs+1;
figindex.axes=figindex.axes+1;
figindex.plts=figindex.plts+1;

handles.figs{figindex.figs}=figure();

figprop.figs{figindex.figs,1}.position = figprop.figs{figindex.figs-1,1}.position+[figprop.figs{figindex.figs-1,1}.position(3), 0, 0, 0];
figprop.axes{figindex.figs,1}.ColorMap = gray(1024);
figprop.axes{figindex.figs,1}.parent = handles.figs{figindex.figs};
figprop.plts{figindex.figs,1}.SliceDirection=[1,0,0];
figprop.plts{figindex.figs,1}.SliceNumber=1;
figprop.plts{figindex.figs,1}.ScaleFactors =[1,5,1];
figprop.axes{figindex.figs,1}.clim=[0 1];


img_slice_viewer(images_cr.pvals.gray(la_index,tt), figprop.figs{figindex.figs,1}, figprop.axes{figindex.figs,1}, figprop.plts{figindex.figs,1})
set(handles.figs{figindex.figs},'Position',figprop.figs{figindex.figs,1}.position);
