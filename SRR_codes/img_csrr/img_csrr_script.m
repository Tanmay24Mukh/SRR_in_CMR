%%
% Project: SRR in CMR: Super Resolution Reconstruction in Cardiac Magnetic
% Resonance
%
% This is the script for reading & combining Short Axis & Long Axis dicom
% images
%======>img_csrr_script:
%
%
%
%
%
%
%======

%%
%========

clc;
clear all;
close all;
%%
%========
params.par.coordsRconst=false;
%%  Study IDs
%======== Specify the study ids
study_ids.patient = 'M202'; % Study ID.
study_ids.scan = 'S01'; % S01 - orthogonal (SR-O) and S02 - radial (SR-R)
study_ids.images_used = 'SA_1.0_LA_1.0'; % 1.0 is true 0.0 is false
study_ids.param_id = 'linear_I_0.50_C_0.25_H_0.50_X00'; % Based on SR grid parameters and interpolation scheme
%% Set dirs
%========
dirs.mfile_libraries_root=pwd; % Repo Directory
dirs.project_root = fullfile(pwd,'Datasets\'); % Dataset directory

%%
%========
cd(dirs.mfile_libraries_root);

%% MATLAB LIBs
%========Load libraries
matlab_libs = {...
    'data_structs', 'img_process',...
    'utility',...
    'utility/struct', 'utility/convex_hull', 'utility/cell', ...
    'utility/img', 'utility/contours', 'utility/plots'...
    'img_dicom', 'img_plot', 'img_csrr',...
   };

matlab_libs_array = {dirs.mfile_libraries_root, matlab_libs};
dirs.mfile_libraries = matlab_load_libs(matlab_libs_array);

%% List of output filenames:
%========
img_csrr_load_output_filenames;

%% 
%======== Make the dirs, filenames, files, etc.
[study_ids, dirs, filenames, files] = img_dirgen(study_ids, dirs, filenames, matlab_libs);

%% Create the data strcts
%========image data structs:
ds_img_nestedcell = img_struct_cells();

images_o = cell2struct_nested(ds_img_nestedcell);
images_cr = cell2struct_nested(ds_img_nestedcell);
images_res = cell2struct_nested(ds_img_nestedcell); 
cntr_res = cell2struct_nested(ds_img_nestedcell);
images_SR = cell2struct_nested(ds_img_nestedcell);

%%
%======== Read dicom files
[images_o.pvals.raw, images_o.map, images_o.info] = dicom_read_2_4D(dirs.images_sorted);
%%
%========================
%========================	Set the dataset properties & super res. params
%========================
%%
%========   which images are being used? 0 means none, 1 means all, 2 means
%every other image
im2use_stepsize_SA=1; %
im2use_stepsize_LA=1; %

%%
%======== images_o: Original images
images_o.props.LA.index =  1:1:6; %
images_o.props.SA.index = 7:1:15; %check the image folder & contours csv files

images_o.props.timestep = 0.2/8; %unit: seconds

images_o.props.LA.has_contours = false;
images_o.props.LA.flip_contours = false;

images_o.props.SA.has_contours = true;
images_o.props.SA.flip_contours = true;
%========
im2use_index_SA = 1:im2use_stepsize_SA:length(images_o.props.SA.index);
im2use_index_LA = 1:im2use_stepsize_LA:length(images_o.props.LA.index);
%========
images_o.props.SA.img_dim = [double(images_o.info{images_o.props.SA.index(1),1}.Rows) double(images_o.info{images_o.props.SA.index(1),1}.Columns) 1];
images_o.props.LA.img_dim = [double(images_o.info{images_o.props.LA.index(1),1}.Rows) double(images_o.info{images_o.props.LA.index(1),1}.Columns) 1];

images_o.props.SA.PixelSpacing = [images_o.info{images_o.props.SA.index(1),1}.PixelSpacing(1) images_o.info{images_o.props.SA.index(1),1}.PixelSpacing(2) images_o.info{images_o.props.SA.index(1),1}.SliceThickness];
images_o.props.LA.PixelSpacing = [images_o.info{images_o.props.LA.index(1),1}.PixelSpacing(1) images_o.info{images_o.props.LA.index(1),1}.PixelSpacing(2) images_o.info{images_o.props.LA.index(1),1}.SliceThickness];

images_o.props.SA.xyz_aspectratio = images_o.props.SA.PixelSpacing./images_o.props.SA.PixelSpacing(1);%
images_o.props.LA.xyz_aspectratio = images_o.props.LA.PixelSpacing./images_o.props.LA.PixelSpacing(1);
%%
%======== images_cr  parameters

images_cr.props.LA.index = images_o.props.LA.index;
images_cr.props.SA.index = images_o.props.SA.index;

images_cr.params.LA.crop_dims =  [30 30; 60 30; 0 0]; %
images_cr.params.SA.crop_dims =  [45 60; 45 45; 0 0]; %

images_cr.props.LA.has_contours = images_o.props.LA.has_contours;
images_cr.props.LA.flip_contours = images_o.props.LA.flip_contours ;

images_cr.props.SA.has_contours = images_o.props.SA.has_contours;
images_cr.props.SA.flip_contours = images_o.props.SA.flip_contours ;

images_cr.params.crop_dims = ...
    img_sr_sala_croproi_maker(images_cr.params.SA.crop_dims, images_cr.params.LA.crop_dims, ...
    images_o.props.SA.index, images_o.props.LA.index, ...
    images_cr.props.SA.index, images_cr.props.LA.index, ...
    size(images_o.pvals.raw));

%%
%======== SALA resampled images
images_res.params.SA.lr2hr_psize_ratio=[0.5 0.5 0.5];
images_res.params.LA.lr2hr_psize_ratio=[0.5 0.5 0.5];

images_res.params.SA.expand = [0,0; 0,0; 0,0];
images_res.params.LA.expand = [0,0; 0,0; 0,0];

images_res.params.SA.index_used = images_o.props.SA.index(im2use_index_SA);
images_res.params.LA.index_used = images_o.props.LA.index(im2use_index_LA);

images_res.params.SA.resample_ratio = images_res.params.SA.lr2hr_psize_ratio.*1./(images_o.props.SA.xyz_aspectratio.*[1, 1, im2use_stepsize_SA]);
images_res.params.LA.resample_ratio = images_res.params.LA.lr2hr_psize_ratio.*1./(images_o.props.LA.xyz_aspectratio.*[1, 1, im2use_stepsize_LA]);
% images_res.params.LA.resample_ratio(3)=1;

images_res.params.LA.crop_dims = images_cr.params.LA.crop_dims;
images_res.params.SA.crop_dims =  images_cr.params.SA.crop_dims;

images_res.params.LA.has_contours = images_o.props.LA.has_contours;
images_res.params.LA.flip_contours = images_o.props.LA.flip_contours ;


images_res.params.SA.has_contours = images_o.props.SA.has_contours;
images_res.params.SA.flip_contours = images_o.props.SA.flip_contours ;


images_res.params.SA.interp.img{1} = 'linear';
images_res.params.SA.interp.coords{1} = 'linear';

images_res.params.LA.interp.img{1} = 'linear';
images_res.params.LA.interp.coords{1} = 'linear';
%%
%======== resampled contours:
cntr_res.params.SA.lr2hr_psize_ratio=[0.25 0.25 0.25];
cntr_res.params.LA.lr2hr_psize_ratio=[0.25 0.25 0.25];

cntr_res.params.SA.expand = [0, 0; 0, 0; 0, 0];
cntr_res.params.LA.expand = [0, 0; 0, 0; 0, 0];


cntr_res.params.SA.index_used = images_o.props.SA.index(im2use_index_SA);
cntr_res.params.LA.index_used = images_o.props.LA.index(im2use_index_LA);

cntr_res.params.SA.resample_ratio = cntr_res.params.SA.lr2hr_psize_ratio.*1./(images_o.props.SA.xyz_aspectratio.*[1, 1, im2use_stepsize_SA]);
cntr_res.params.LA.resample_ratio = cntr_res.params.LA.lr2hr_psize_ratio.*1./(images_o.props.LA.xyz_aspectratio.*[1, 1, im2use_stepsize_LA]);
% cntr_res.params.LA.resample_ratio(3)=1;

cntr_res.params.LA.crop_dims = images_res.params.LA.crop_dims;
cntr_res.params.SA.crop_dims =  images_res.params.SA.crop_dims;

cntr_res.params.LA.has_contours = images_res.params.LA.has_contours;
cntr_res.params.LA.flip_contours = images_res.params.LA.flip_contours;


cntr_res.params.SA.has_contours = images_res.params.SA.has_contours;
cntr_res.params.SA.flip_contours = images_res.params.SA.flip_contours;


cntr_res.params.SA.interp.img{1} = images_res.params.SA.interp.img{1};
cntr_res.params.SA.interp.coords{1} = images_res.params.SA.interp.coords{1};

cntr_res.params.LA.interp.img{1} = images_res.params.LA.interp.img{1};
cntr_res.params.LA.interp.coords{1} = images_res.params.LA.interp.coords{1} ;

%%
%======== Super Res. parameters
images_SR.params.lr2hr_psize_ratio = [0.5 0.5 0.5]; % the images_res steps makes everything isometric so all values, here, are equal

images_SR.params.expand = [0 ,0; 0, 0 ;0, 0];

images_SR.params.resample_ratio = images_SR.params.lr2hr_psize_ratio.*1./images_o.props.SA.xyz_aspectratio;
images_SR.params.timestep_last=size(images_o.pvals.raw, 2);

images_SR.params.interp.img{1} = 'linear'; % natural \ Linear
images_SR.params.interp.img{2} = 'linear'; % none \ Linear

%%
%========
params.study_ids = study_ids.param_id;
%% 

%%
%========time steps
t_last=images_SR.params.timestep_last;
params.images_SR.t_last=t_last;
%%
%========================
%======================== CSRR Starts:
%========================
%%
%======== Get image pixel coords in RCS & convert to grayscale
[images_o.pvals.gray, images_o.coords.RCS.X, images_o.coords.RCS.Y, images_o.coords.RCS.Z] = ...
    dicom_gpvals_n_rcscoords(images_o, size(images_o.pvals.raw,2));

%%
%======== Crop the RCS coord & gr images
kk_counter=0;

disp('Crop the RCS coord & gr images');
for tt = 1:1:t_last
    for kk = 1:size(images_o.pvals.raw,1)
        if ~isnan(images_cr.params.crop_dims{kk,tt})
            kk_counter = kk_counter+1;
            
            images_cr.pvals.gray{kk_counter,tt} = img_process_crop(images_o.pvals.gray{kk,tt},images_cr.params.crop_dims{kk,tt});
            
            images_cr.coords.RCS.X{kk_counter,tt} = img_process_crop(images_o.coords.RCS.X{kk,tt}, images_cr.params.crop_dims{kk,tt});
            images_cr.coords.RCS.Y{kk_counter,tt} = img_process_crop(images_o.coords.RCS.Y{kk,tt}, images_cr.params.crop_dims{kk,tt});
            images_cr.coords.RCS.Z{kk_counter,tt} = img_process_crop(images_o.coords.RCS.Z{kk,tt}, images_cr.params.crop_dims{kk,tt});
        end
    end
    
    kk_counter = 0;
end

%%
%======== set the props for image structs

SA_start_cr = img_sa_start_index(images_cr.params.crop_dims(:,1), length(images_o.props.SA.index));
images_o.props.LA.index_cr = 1:1:SA_start_cr-1;
images_o.props.SA.index_cr = SA_start_cr:1:size(images_cr.coords.RCS.Z,1);

images_cr.props.LA.img_dim = [size(images_cr.pvals.gray{images_o.props.LA.index_cr(1),1}), length(images_o.props.LA.index_cr)];
images_cr.props.SA.img_dim = [size(images_cr.pvals.gray{images_o.props.SA.index_cr(1),1}), length(images_o.props.SA.index_cr)];
images_cr.props.LA.index = images_o.props.LA.index_cr;
images_cr.props.SA.index = images_o.props.SA.index_cr;
images_cr.props.LA.PixelSpacing = images_o.props.SA.PixelSpacing;
images_cr.props.SA.PixelSpacing = images_o.props.LA.PixelSpacing;
%%
%========
%	which XYZs fall in which region (ROI based)?
%========
%%
%======== images_res: isometric images -- resampled SALAs
images_res = ...
    img_struct_resampler(...
    images_cr, t_last, images_res.params, ...
    files.contours.LA.LV.endo, files.contours.LA.LV.epi,...
    files.contours.SA.LV.endo, files.contours.SA.LV.epi, params.par.coordsRconst);


%%
%======== cntr_res: isometric images -- contours from resampled SALAs
cntr_res = ...
    img_struct_resampler(...
    images_cr, t_last, cntr_res.params, ...
    files.contours.LA.LV.endo, files.contours.LA.LV.epi,...
    files.contours.SA.LV.endo, files.contours.SA.LV.epi, params.par.coordsRconst);

cntr_res.params = cntr_res.params;

%%
%======== generate the query points (HR grid)

XYZ_HR.X = cell(1,1);
XYZ_HR.Y = cell(1,1);
XYZ_HR.Z = cell(1,1);

for tt=1:size(XYZ_HR.X,2)
    [XYZ_HR.X{tt}, XYZ_HR.Y{tt}, XYZ_HR.Z{tt}] = img_process_resample_coords(...
        images_cr.coords.RCS.X(images_cr.props.SA.index ,tt),...
        images_cr.coords.RCS.Y(images_cr.props.SA.index ,tt),...
        images_cr.coords.RCS.Z(images_cr.props.SA.index ,tt), images_SR.params.resample_ratio, images_SR.params.expand);
end

%%
%======== Assign pixels in RCS (SA + LA) to various ROIs
roi_ids = [max(cell2arr_1D(images_res.ROI.LV)) min(cell2arr_1D(images_res.ROI.LV))];
%%
%==>
ROIs_LR = points_in_rois(...
    images_res.coords.RCS,...
    cntr_res.coords.RCS,...
    cntr_res.props.SA.index,...
    cntr_res.ROI.LV3D.SA, ...
    roi_ids, t_last, params.par.coordsRconst);

ROIs_HR = points_in_rois(...
    XYZ_HR, ...
    cntr_res.coords.RCS, ...
    cntr_res.props.SA.index,...
    cntr_res.ROI.LV3D.SA, ...
    roi_ids, t_last, params.par.coordsRconst);
%%
%======== Construct the interpolants
%%
%======== 
roi_ids(3)=3; 

img_sr_interpolant = img_sr_interpolant(...
    images_res.pvals.gray,...
    images_res.coords.RCS, ...
    ROIs_LR, roi_ids, ...
    images_SR.params.interp.img,...
    t_last, params.par.coordsRconst); %||%
%%
%======== 
%%
%======== Generate the super res images
img_3D_sr = img_sr_imgen(img_sr_interpolant, XYZ_HR, ROIs_HR, roi_ids, t_last, params.par.coordsRconst);

images_SR.study_ids = study_ids.param_id;
%%


%%
%========
for tt=1:1:t_last
    for kk=1:size(img_3D_sr{1,tt},3)
        images_SR.pvals.gray{kk,tt}=img_3D_sr{1,tt}(:,:,kk);
    end
end
images_SR.props.img_dim=[size(images_SR.pvals.gray{1,1}), size(images_SR.pvals.gray,1)];
%%
%======== save results
save(files.outputs.images{1},'images_o', '-v7.3');
save(files.outputs.images{2},'images_cr', '-v7.3');
save(files.outputs.images{3},'images_res', '-v7.3');
save(files.outputs.images{4},'cntr_res', '-v7.3');
save(files.outputs.images{5},'images_SR', '-v7.3');

save(files.outputs.results{2},'ROIs_LR', '-v7.3');
save(files.outputs.results{3},'ROIs_HR', '-v7.3');

%%
%======== 
params.images_SR.t_last=t_last;

%%
%======== 
img_viewer_crVsr_script;
%%
