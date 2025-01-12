dirs.mfile_libraries_root=pwd;
matlab_libs = {
    'utility',...
    'utility/cell',
   };

matlab_libs_array = {dirs.mfile_libraries_root, matlab_libs};
dirs.mfile_libraries = matlab_load_libs(matlab_libs_array);

data_direc = "D:\CSRR\Datasets\Validation_LR";
img_direc = fullfile(data_direc, "img");
protocol_id = "Orthogonal";


la_img_direc = fullfile(img_direc,protocol_id, "LA");
sa_img_direc = fullfile(img_direc,protocol_id, "SA");

t_last = 56; t_skip = 2;

la_images = img_read_dicom_4D(la_img_direc, t_last, t_skip);
sa_images = img_read_dicom_4D(sa_img_direc, t_last, t_skip);
images.pvals.raw = vertcat(la_images.img,sa_images.img);
images.map = vertcat(la_images.map,sa_images.map);
images.info = vertcat(la_images.info,sa_images.info);

sa_index = size(la_images.img,1)+1:1:size(images.pvals.raw,1);
expand = [0,0;0,0;0,0];
resample_ratio = [0.5,0.5,0.1];
interp_method = {'linear', 'linear'};
interp_SR_method = {'linear', 'linear'};
t_last = t_last/t_skip + 1;
% t_last = size(images.pvals.raw,2);

cntrs_used = false;
coordsRconst = false;

ext_fid = strcat(protocol_id,"_resample_L_",num2str(resample_ratio(1)),"_W_",num2str(resample_ratio(2))...
    ,"_H_",num2str(resample_ratio(3)) ,"_",interp_SR_method{1});
outputs_direc = fullfile(data_direc, "results", protocol_id);
fid.outputs.direc = outputs_direc;

if ~isfolder(fid.outputs.direc)
    mkdir(fid.outputs.direc)
end

fid.outputs.images_lr = fullfile(fid.outputs.direc,strcat("Images_lr_",ext_fid,".mat"));
fid.outputs.images_iso = fullfile(fid.outputs.direc,strcat("Images_iso_",ext_fid,".mat"));
fid.outputs.images_sr = fullfile(fid.outputs.direc,strcat("Images_sr_",ext_fid,".mat"));


[images.pvals.gray, images.RCS.X, images.RCS.Y, images.RCS.Z] = dcm_img_2_xyz_coords(images);

[images_iso.pvals.gray, images_iso.RCS.X, images_iso.RCS.Y, images_iso.RCS.Z] = Img_2_Isometric(images.pvals.gray,...
                        images.RCS.X, images.RCS.Y, images.RCS.Z,...
                        resample_ratio, expand,interp_method,...
                        t_last, cntrs_used, coordsRconst);
XYZ_HR.X = cell(1,1);
XYZ_HR.Y = cell(1,1);
XYZ_HR.Z = cell(1,1);

for tt=1:size(XYZ_HR.X,2)
    [XYZ_HR.X{tt}, XYZ_HR.Y{tt}, XYZ_HR.Z{tt}] = Img_Process_Resample_Coords(...
        images.RCS.X(sa_index ,tt),...
        images.RCS.Y(sa_index ,tt),...
        images.RCS.Z(sa_index ,tt), resample_ratio, expand);
end

ROIs_LR =0; roi_ids = 1;
%%
img_sr_interpolant = Img_SR_Interpolant(...
    images_iso.pvals.gray,...
    images_iso.RCS, ...
    ROIs_LR, roi_ids, ...
    interp_SR_method,...
    t_last, coordsRconst); %||%

%%
img_3D_sr = Img_SR_Img_Gen(img_sr_interpolant, XYZ_HR, roi_ids, t_last, coordsRconst);

%%
for tt=1:1:t_last
    for kk=1:size(img_3D_sr{1,tt},3)
        images_SR.pvals.gray{kk,tt}=img_3D_sr{1,tt}(:,:,kk);
    end
end

images_SR.interp_method = interp_SR_method;
images_SR.resample_ratio = resample_ratio;

%======== save results
save(fid.outputs.images_lr,'images' ,'-v7.3');
save(fid.outputs.images_iso,'images_iso', '-v7.3');
save(fid.outputs.images_sr,'images_SR', '-v7.3');


function [gray,X,Y,Z] = dcm_img_2_xyz_coords(images)

raw = images.pvals.raw;
info = images.info;
k_size = size(raw, 1);
t_last = size(raw,2);

gray = cell(size(raw));
X =  cell(size(raw));
Y  = cell(size(raw));
Z  = cell(size(raw));

for tt=1:t_last
    for kk = 1:k_size
        [X{kk,tt}, Y{kk,tt}, Z{kk,tt}] = Img_2_RCS(raw{kk,tt}, info{kk,tt});
        BS = info{kk,tt}.BitsStored;
        gray{kk,tt} = mat2gray(raw{kk,tt},[0, double(2.^BS-1)]);
    end
end

end



function mfile_dirs = matlab_load_libs(matlab_libs_array)

for ii=1:size(matlab_libs_array,1)
    mfile_dirs_root = matlab_libs_array{ii,1};
    matlab_libs = matlab_libs_array{ii,2};
    
    mfile_dirs = cellfun(@(x) fullfile(mfile_dirs_root,x), matlab_libs,'UniformOutput',false);

    addpath(mfile_dirs{:})
end

end
