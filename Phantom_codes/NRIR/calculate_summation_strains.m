function results = calculate_summation_strains(results, t_start, t_end)
%% Calculate the Strains (Eulerian + Lagrangian), D_mag,...
for tt= t_start:t_end-1
    if ~isempty(results.D_abs{tt})
        results.D_mag{tt}=sqrt(results.D_abs{tt}(:,:,:,1).^2+results.D_abs{tt}(:,:,:,2).^2+results.D_abs{tt}(:,:,:,3).^2);
        results.E_l{tt}=strain_Lagrangian_disp(results.D_abs{tt}(:,:,:,1),results.D_abs{tt}(:,:,:,2),results.D_abs{tt}(:,:,:,3));
    else
        results.D_mag{tt} = [];
        results.E_l{tt} = [];
    end
end

end