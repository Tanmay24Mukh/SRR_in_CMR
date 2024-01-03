
dataset = "D:\\FE_validation\\Datasets\\";
study = "M202";

image_dataset = fullfile(dataset, study, "Images");
results_dataset = fullfile(dataset, study, "Results");
% load(fullfile(results_dataset,"M202_img_propogation_results_3D_v2.mat"));


for k = 10
    avg_vals = [];
    for t = 3:16
        strains = results.E_l_polar_masked{t}(:,:,k,1,1);
        % avg_vals = [avg_vals,nanmean(strains(:))];
        avg_vals = [avg_vals,nanmean(strains(strains < 0))];
        % disp(avg_strain)
    end
end

avg_vals = avg_vals';