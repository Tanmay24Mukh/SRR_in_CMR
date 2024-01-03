%%
%   Maps the CMR results on the STL files (3D)
%   
% 
%======> results_2_STL:
%
%
%
%
%
%
%======
% Developed by MK on 2021_10_11
% Last rev. by MK on 2022_03_07
%
% This is a work in progress.
%%
%========
%%
clc;
close all;
clear all;
%%
%% Set dirs
%========
study_name='M04';
%%
dir.mfile_libraries_root='C:\Users\kxm\Documents\TAMU\Project_01\Codes\';
dir.root='C:\Users\kxm\Documents\TAMU\Project_01\';
%%
dir.datasets=fullfile(dir.root,'Datasets');
dir.study_name=fullfile(dir.datasets,study_name);
%%
%========load libraries
dir.mfile_libraries={...
    strcat(dir.mfile_libraries_root,'img_readers'),...
    strcat(dir.mfile_libraries_root,'img_process'),...
    strcat(dir.mfile_libraries_root,'contours'),...
    strcat(dir.mfile_libraries_root,'img_reg'),...
    strcat(dir.mfile_libraries_root,'strain'),...
    strcat(dir.mfile_libraries_root,'STL')};

addpath(dir.mfile_libraries{:});
%%
%========load libraries
dir.mfile_libraries={...
    strcat(dir.mfile_libraries_root,'img_readers'),...
    strcat(dir.mfile_libraries_root,'img_process'),...
    strcat(dir.mfile_libraries_root,'plots'),...
    strcat(dir.mfile_libraries_root,'saveas'),...
    strcat(dir.mfile_libraries_root,'img_plot'),...
    strcat(dir.mfile_libraries_root,'contours'),...
    strcat(dir.mfile_libraries_root,'strain'),...
    strcat(dir.mfile_libraries_root,'STL')};

addpath(dir.mfile_libraries{:});
%%
%========Load contours 
dir.contours=fullfile(dir.study_name,strcat(study_name,'_Contours'));
filename.contours=strcat(study_name,'_SA_LV');
filename.endo=fullfile(dir.contours, [filename.contours '_Endo.csv']);
filename.epi=fullfile(dir.contours, [filename.contours '_Epi.csv']);
%%
%========Read Dicom files 
dir.input_dicom=fullfile(dir.study_name,strcat(study_name,'_img'),strcat(study_name,'_img_dicom_Sorted'));%
images=img_readDicom_4D(dir.input_dicom);
%%
%========Set output dir
dir.output=fullfile(dir.study_name,strcat(study_name,'_results'));
filename.output.results=fullfile(dir.output, strcat(study_name,'_results_3D'));
%%
%========Set STL dir & filenames
filename.STL.type='LV'; %LV, RV, or bivent

filename.STL.timestep.main='07';
filename.STL.timestep.shadow='01';

filename.STL.stl_main = ...
                [study_name,'_', filename.STL.type, '_',...
                filename.STL.timestep.main,'.stl' ];%'M04_LV_t07.stl';
            
% filename.STL.stl_shadow=[study_name,'_', filename.STL.type, '_',...
%                 filename.STL.timestep.shadow,'.stl' ];

dir.STLs=fullfile(dir.output,[study_name,'_STLs']);

filename.STL.stl_main=fullfile(dir.STLs,filename.STL.stl_main);
filename.STL.stl_shadow=fullfile(dir.STLs, filename.STL.stl_shadow);
%%
%========image dataset prop
img.Properties.index_SA=[2,8]; %check the image folder & contours csv files
img.Properties.img_Dim=[images.info{1,1}.Height images.info{1,1}.Width img.Properties.index_SA(2)-img.Properties.index_SA(1)+1];
img.Properties.pixelDim=[images.info{1,1}.PixelSpacing(1) images.info{1,1}.PixelSpacing(1) images.info{1,1}.SliceThickness]; %pixel dimension in mm
img.Properties.xyz_aspectratio=img.Properties.pixelDim./img.Properties.pixelDim(1);%[1 1 5];
img.Properties.resample_ratio=[0.5 0.5 0.5].*1./img.Properties.xyz_aspectratio;
img.Properties.crop_ROI=[40 60; 40 60; 0 0]; %1st row: in y dir , 2nd row: in x dir

img.Properties.timestep=30.3030e-3; %unit: seconds
%=====
%%
% range_Z=[1 6];
% img_Dim=img.Properties.img_Dim;
% ratios=[size(contours.initial{1,1},1) 6*5];
%%
%========Load Previous results?
load(filename.output.results);
%%
%========Set the time point we want to plot
desired_timepoint=7;
values=squeeze(results.E_rate_polar{desired_timepoint}(:,:,:,2,2));
%%
%========Read the STL file
[v_main, f_main, n_main, name_main]=stlRead(filename.STL.stl_main);
%%
%========Transfer vertices coordinates
v_main_new=stl_vertice_coord_transfer(v_main, ...
    Properties.pixelDim, img.Properties.crop_ROI, img.Properties.resample_ratio);
%%
%========

%%
%========get image dims
img_size = size(results.img.resampled{desired_timepoint});
%%
%========Make the main object
object_main=[];
[object_main, colors_new, gray_zone] = stl_map_results(img_size, v_main_new, f_main);
%%
%========Make the gray object (in case we have one)
object_gray.vertices=v_main_new(gray_zone,:);
gray_zone_f=[];
for ii=1:size(f_main,1) 
    if(sum(f_main(ii,1)==gray_zone) && sum(f_main(ii,2)==gray_zone) && sum(f_main(ii,3)==gray_zone))     
        gray_zone_f(end+1)=ii;
    end
end
f_gr=f_main(gray_zone_f,:);
[B, I]=sort(f_gr(:));

object_gray.faces=reshape(I,size(f_gr));%;f(gray_zone_f,:);
colors_gzone=repmat([1 0 0],size(object_gray.vertices,2));
%%
%========

%%
%%========

%%
%======== Plot the results
handles.axes=[];
handles.figure{1}=figure();
handles.axes{1}=axes(handles.figure{1});
handles.plt{1}=patch(object_main,'FaceVertexCData',colors_new, ...
    'FaceColor','interp',...
    'FaceAlpha',1,...
    'EdgeColor',       'none',        ...
    'FaceLighting',    'gouraud',     ...
    'AmbientStrength', 1);

hold on;
%
set([handles.axes{:}],'visible','off','DataAspectRatio',[1,1,1]);
view([handles.axes{1}],[cross(v_main_new(1,:)-v_main_new(end,:),v_main_new(1,:)-v_main_new(3,:))]);
%
ticks_color=-10:5:10;
caxis([handles.axes{1}],[ticks_color(1) ticks_color(end)]);
colormap(handles.axes{1},'Spring');
colorbar([handles.axes{1}],'XTickLabel',{num2str(ticks_color(:))}, ...
               'XTick', ticks_color);
%
set([handles.axes{:}],'FontName','Times','FontSize',12);
%view([19.0767   21.6000]);%[-1.1805   18.0000]
    
pbaspect(handles.axes{1},[1 1 1])
hold off;
%%

%%
