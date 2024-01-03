function results = calculate_propogation_strains(results, t_start, t_end)
flag = 0;
for tt= t_start:t_end-1
    
    results.D_mag{tt}=sqrt(results.D_abs{tt}(:,:,:,1).^2+results.D_abs{tt}(:,:,:,2).^2+results.D_abs{tt}(:,:,:,3).^2);

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

    results.E_l{tt} = E;
    flag = 1;


end
end