%%
%This one reads all the dicom files in a folder and assembles them to 3D images 
%
%
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
% Developed by MK on 2021_02_03
% Last rev by MK on 2021_12_04
%
%======> This is a work in progress.
%%
clc;
clear all;
close all;
%%

%%
%load libraries
dir_mfile_libraries={'D:\Maziyar\TAMU\Project_1\GitHub\Codes\MATLAB_img_reg\img_readers',...
    'D:\Maziyar\TAMU\Project_1\GitHub\Codes\MATLAB_img_reg\img_process',...
    'D:\Maziyar\TAMU\Project_1\GitHub\Codes\MATLAB_img_reg\plots',...
    'D:\Maziyar\TAMU\Project_1\GitHub\Codes\MATLAB_img_reg\saveas',...
    'D:\Maziyar\TAMU\Project_1\GitHub\Codes\MATLAB_img_reg\img_plot'};

addpath(dir_mfile_libraries{:});
%%
dir_root='D:\Maziyar\TAMU\Project_1\img_Data\Test Mouse 4\M04_img_dicom_Sorted';
dir_output='D:\Maziyar\Project_1\img_Data\Dec 2020 db-db Mice\20201208_105807_IRC676_Mouse761_1_1\M761';
folder_name_Prefix='M04_';
%%
% img_dicom_list = dir(fullfile(dir_root, '**\*.dcm'));  %get list of files and folders in any subfolder
% img_dicom_list = img_dicom_list(~[img_dicom_list.isdir]);  %remove folders from list
% img_dicom_list=sort_struct(img_dicom_list,'folder'); %sort structure by folder
%%
% collection=dicomCollection(dir_root,'IncludeSubfolders',true);
% collection.Properties.VariableNames([14]) = { 'filenames'};
images=img_readDicom_4D(dir_root);

img_Dim=[160 160 9];
img_resolution=[0.2 0.2 1];
xy_z_ratio=5;
%
%V=zeros(img_Dim(1),img_Dim(2),img_Dim(3)*xy_z_ratio);
for (tt=1:size(images.img,2))
    V{tt}=reshape([images.img{2:end,tt}],img_Dim(1),img_Dim(2),img_Dim(3));
    V_1{tt}=img_process_resample(V{tt},[1 1 0.2]);
    
end
%%
% x=1:1:img_Dim(1)*img_resolution(1);
% y=1:1:img_Dim(2)*img_resolution(2);
% z=1:1:img_Dim(3)*img_resolution(3);
% [X Y Z]=meshgrid(x,y,z);
%%
intensity = [0 20 40 120 220 1024];
alpha = [0 0 0.15 0.3 0.38 0.5];
color = ([0 0 0; 43 0 0; 103 37 20; 199 155 97; 216 213 201; 255 255 255])/ 255;
queryPoints = linspace(min(intensity),max(intensity),256);
alphamap = interp1(intensity,alpha,queryPoints)';
colormap = interp1(intensity,color,queryPoints);

ViewPnl = uipanel(figure,'Title','4-D Dicom Volume');

volshow(V_1,'Colormap',colormap,'Alphamap',alphamap,'Parent',ViewPnl);
