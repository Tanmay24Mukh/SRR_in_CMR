
dataset = "D:\\FE_validation\\Datasets\\";
study = "M202";

image_dataset = fullfile(dataset, study, "Images");
results_dataset = fullfile(dataset, study, "Results");
load(fullfile(results_dataset,"M202_img_results_3D.mat"));

t_start = 1;
t_end = 11;

% total_deformation_gradient = [];
flag = 0;

% Calculating the propogated deformation gradient

for tt= t_start:t_end-1


    deformation_gradient = img_deform_gradient_propogation(results.D{tt}(:,:,:,1),results.D{tt}(:,:,:,2),results.D{tt}(:,:,:,3));


    for i = 1:size(deformation_gradient, 1)
        for j = 1:size(deformation_gradient, 2)
            for k = 1:size(deformation_gradient, 3)

                if flag == 0
                    total_deformation_gradient(i,j,k,:,:) = deformation_gradient(i,j,k,:,:);
                elseif flag > 0
                    total_deformation_gradient(i,j,k,:,:) = pagemtimes(total_deformation_gradient(i,j,k,:,:),deformation_gradient(i,j,k,:,:));
                end

                C = pagemtimes(pagetranspose(total_deformation_gradient(i,j,k,:,:)),total_deformation_gradient(i,j,k,:,:));
                E_single = (1/2)*(reshape(C,3,3) - eye(3));
                E(i,j,k,:,:) = E_single;

            end
        end
    end

    Lagrangian_strain{tt} = E;
    flag = 1;


end

%% Mask ROI

for tt= t_start+1:t_end
    temp=results.img.resampled{tt};
    temp(temp < 0.3)= nan; %ROI is 1
    temp(temp >= 0.3)= 1;
    results.img.masked{tt-1} = temp;
    ROI{tt-1}=temp;
end

maskROI=1;

if(maskROI==1)
    for tt = t_start:t_end-1
        for z = 1:size(results.img.resampled{tt},3)

            Lagrangian_strain_masked{tt}(:,:,z,:,:) = Lagrangian_strain{tt}(:,:,z,:,:).*ROI{tt}(:,:,z);

        end
    end
end

[results] = test_propogate_cart_2_polar_strains(results, Lagrangian_strain_masked);

% Populating the lagrange strain tensor.
