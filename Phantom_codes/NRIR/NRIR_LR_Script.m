data_direc = "D:\CSRR\Datasets\Validation";
img_direc = fullfile(data_direc, "img");
protocol_id = "Orthogonal";



outputs_direc = fullfile(data_direc, "results", protocol_id);
fid.outputs.direc = outputs_direc;

resample_ratio = [0.5,0.5,0.1];
interp_SR_method = {'linear', 'linear'};

ext_fid = strcat(protocol_id,"_resample_L_",num2str(resample_ratio(1)),"_W_",num2str(resample_ratio(2))...
    ,"_H_",num2str(resample_ratio(3)) ,"_",interp_SR_method{1});


fid.outputs.images_lr = fullfile(fid.outputs.direc,strcat("Images_lr_",ext_fid,".mat"));
fid.outputs.strains_lr = fullfile(fid.outputs.direc,strcat("Img_reg_results_lr_",ext_fid,".mat"));

%% Loading low_resolution and super-resolution images
% load(fid.outputs.images_lr)
% load(fid.outputs.images_sr)


dataset = "D:\\FE_validation\\Datasets\\";
study = "M202";

image_dataset = fullfile(dataset, study, "Images_15");
img_skip = 2;
frame_skip = 1;

z_planes = readmatrix(fullfile(image_dataset,"plane_z_locations.txt"));
z_plane_thickness = (z_planes(2) - z_planes(1))/2;

images = img_read_pngs(image_dataset);

% Setting img_properties
img.Properties.index_SA = 1:img_skip:17;

% img.Properties.img_Dim=[images.info{1,1}.Height, images.info{1,1}.Width, ...
%     img.Properties.index_SA(end)-img.Properties.index_SA(1)+1];

img.Properties.img_Dim=[images.info{1,1}.Height, images.info{1,1}.Width, ...
    length(img.Properties.index_SA)];


img.Properties.pixelDim = [1 1 z_plane_thickness]; %pixel dimension in mm
img.Properties.xyz_aspectratio=img.Properties.pixelDim./img.Properties.pixelDim(1);%[1 1 5];
img.Properties.xyz_aspectratio= [1,1,2];
img.Properties.resample_ratio=[0.5 0.5 0.5].*1./img.Properties.xyz_aspectratio;
% img.Properties.crop_ROI=[30 35;20 30; 0 0];
img.Properties.crop_ROI=[10 1;10 1; 0 0];

img_reg_Smoothing= 1;
img_reg_iterations=[500 400 300];
total_scan_time = size(images.img,2);

t_start = 1; t_end = total_scan_time; 
img_Disp_Dim = 3;

slice_z = 0;

for tt=1:size(images.img,2)

    img.original{tt}=reshape([images.img{img.Properties.index_SA(1):img_skip:img.Properties.index_SA(end),tt}],...
        img.Properties.img_Dim(1),img.Properties.img_Dim(2),img.Properties.img_Dim(3));

    img.crop{tt}=img_process_crop(img.original{tt},img.Properties.crop_ROI);
    img.grayscale{tt}  = mat2gray(double(img.crop{tt}),[0 255]); % Uncomment for 8 bit images
    % img.resampled{tt}=img_process_resample(img.grayscale{tt},img.Properties.resample_ratio);

end

img.resampled = img.grayscale;
Slice_z=floor(size(img.resampled{1},3)/2);

figure()
montage([img.grayscale{:,8}])

results.img.resampled=img.resampled(:);
results.smoothing = img_reg_Smoothing;
results.iterations = img_reg_iterations;
results.t_start = t_start; results.t_end = t_end;

% %% Diffeomorphic Demons Registration
[results.D,results.img.targetReg]=img_registration_D_Field(img.resampled, ...
    img_reg_iterations,img_reg_Smoothing,img_Disp_Dim,slice_z,t_start,t_end, frame_skip);
%%
% results_D = find(cellfun(@(x)(~isempty(x)),results.D));
results.img.resampled=img.resampled(cellfun(@(x)(~isempty(x)),results.D));
results.D = results.D(cellfun(@(x)(~isempty(x)),results.D));

%% Calculate the absolute displacements (replace the
% timepoint-to-timepoint w/ a ref to timepoint 1

for tt= 1:length(results.D)

        if(tt==1)
            results.D_abs{tt}=results.D{tt};
        elseif (tt > 1)
            results.D_abs{tt}=results.D{tt}+results.D_abs{tt-1};
        end
    % end
end

%% Calculate the Strains (Eulerian + Lagrangian), D_mag,...

    results = calculate_propogation_strains(results, 1, length(results.D)+1);


%% Mask ROI

for tt= 1:length(results.D)
    temp=results.img.resampled{tt};
    temp(temp < 0.3)= nan; %ROI is 1
    temp(temp >= 0.3)= 1;
    results.img.masked{tt} = temp;
    ROI{tt}=temp;
end

maskROI=1;

if(maskROI==1)
    for tt = 1:length(results.D)
        for z = 1:size(results.img.resampled{tt},3)
            results.D_abs_masked{tt}(:,:,z,:,:) = results.D_abs{tt}(:,:,z,:,:).*ROI{tt}(:,:,z)./ROI{tt}(:,:,z);
            results.D_mag_masked{tt}(:,:,z,:,:) = results.D_mag{tt}(:,:,z,:,:).*ROI{tt}(:,:,z)./ROI{tt}(:,:,z);
            results.E_l_masked{tt}(:,:,z,:,:) = results.E_l{tt}(:,:,z,:,:).*ROI{tt}(:,:,z);
            %             results.E_rate_masked{tt}(:,:,z,:,:) = results.E_rate{tt}(:,:,z,:,:).*ROI{tt}(:,:,z);
        end
    end
end
%% Calculate Polar Strains
results.filepath = fid.outputs.strains_lr;
results = cart_2_polar_strains(results);
save(fid.outputs.strains_lr,'results', '-v7.3');

%%
% results.filepath = results_fid;
