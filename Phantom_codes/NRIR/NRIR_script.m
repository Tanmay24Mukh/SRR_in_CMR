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
fid.outputs.images_iso = fullfile(fid.outputs.direc,strcat("Images_iso_",ext_fid,".mat"));
fid.outputs.images_sr = fullfile(fid.outputs.direc,strcat("Images_sr_",ext_fid,".mat"));
fid.outputs.strains_lr = fullfile(fid.outputs.direc,strcat("Img_reg_results_lr_",ext_fid,".mat"));
fid.outputs.strains_sr = fullfile(fid.outputs.direc,strcat("Img_reg_results_sr_",ext_fid,".mat"));

%% Loading low_resolution and super-resolution images
load(fid.outputs.images_lr)
load(fid.outputs.images_sr)

j = 0;
for tt = 1:size(images_SR.pvals.gray,2)
   img.LR{tt} = cat(3, images.pvals.gray{6:end, tt});
   img.SR{tt} = cat(3, images_SR.pvals.gray{:, tt});
end


img_skip = 1;
frame_skip = 1;
img_reg_Smoothing= 1;
% img_reg_iterations=[500 400 300];
% img_reg_iterations=[200 200 100];
total_scan_time = size(img.SR,2);
slice_z = 0;

t_start = 1; t_end = total_scan_time; 
img_Disp_Dim = 3;
results.img.SR=img.SR(:);
results.img.LR=img.LR(:);
results.smoothing = img_reg_Smoothing;
results.iterations = img_reg_iterations;
results.t_start = t_start; results.t_end = t_end;


% %% Diffeomorphic Demons Registration
[results.D,results.img.targetReg]=img_registration_D_Field(img.SR, ...
    img_reg_iterations,img_reg_Smoothing,img_Disp_Dim,slice_z,t_start,t_end, frame_skip);
%%
% results_D = find(cellfun(@(x)(~isempty(x)),results.D));
results.img.SR=imgSR(cellfun(@(x)(~isempty(x)),results.D));
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
    temp=results.img.SR{tt};
    temp(temp < 0.3)= nan; %ROI is 1
    temp(temp >= 0.3)= 1;
    results.img.masked{tt} = temp;
    ROI{tt}=temp;
end

maskROI=1;

if(maskROI==1)
    for tt = 1:length(results.D)
        for z = 1:size(results.img.SR{tt},3)
            results.D_abs_masked{tt}(:,:,z,:,:) = results.D_abs{tt}(:,:,z,:,:).*ROI{tt}(:,:,z)./ROI{tt}(:,:,z);
            results.D_mag_masked{tt}(:,:,z,:,:) = results.D_mag{tt}(:,:,z,:,:).*ROI{tt}(:,:,z)./ROI{tt}(:,:,z);
            results.E_l_masked{tt}(:,:,z,:,:) = results.E_l{tt}(:,:,z,:,:).*ROI{tt}(:,:,z);
            %             results.E_rate_masked{tt}(:,:,z,:,:) = results.E_rate{tt}(:,:,z,:,:).*ROI{tt}(:,:,z);
        end
    end
end
% %% Calculate Polar Strains
results.filepath = fid.outputs.strains_sr;
results = cart_2_polar_strains(results);
save(fid.outputs.strains_sr,'results', '-v7.3');

%%
% results.filepath = results_fid;
