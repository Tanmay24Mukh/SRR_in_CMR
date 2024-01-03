
data_direc = "D:\CSRR\Datasets\Validation";
img_direc = fullfile(data_direc, "img");
protocol_id = "Orthogonal";
study = protocol_id;

outputs_direc = fullfile(data_direc, "results", protocol_id);
fid.outputs.direc = outputs_direc;


dat_file = fullfile(fid.outputs.direc,"dat_files");
rs = results.E_l_polar_masked;
loglist = cellfun(@isempty,rs);
t_end = size(loglist(loglist== false),2);
us = results.D_abs_masked;
if ~isfolder(dat_file)
    mkdir(dat_file);
end

radial_dat = fullfile(dat_file,"radial_strain"); circum_dat = fullfile(dat_file,"circum_strain");
long_dat = fullfile(dat_file,"long_strain");
rad_circ_dat = fullfile(dat_file,"rc_shear_strain");
rad_long_dat = fullfile(dat_file,"rl_shear_strain");
circ_long_dat = fullfile(dat_file,"cl_shear_strain");
D_x_dat = fullfile(dat_file,"D_x");D_y_dat = fullfile(dat_file,"D_y");D_z_dat = fullfile(dat_file,"D_z");

if ~isfolder(radial_dat)
    mkdir(radial_dat);
end

if ~isfolder(circum_dat)
    mkdir(circum_dat);
end

if ~isfolder(long_dat)
    mkdir(long_dat);
end

if ~isfolder(rad_circ_dat)
    mkdir(rad_circ_dat);
end

if ~isfolder(circ_long_dat)
    mkdir(circ_long_dat);
end
if ~isfolder(rad_long_dat)
    mkdir(rad_long_dat);
end

if ~isfolder(D_x_dat)
    mkdir(D_x_dat);
end

if ~isfolder(D_y_dat)
    mkdir(D_y_dat);
end

if ~isfolder(D_z_dat)
    mkdir(D_z_dat);
end


% for t = 1:t_end
for t = 1:size(rs,2)
    strain = rs{t};
    disp = us{t};
    for z = 1:size(strain,3)
        if ~isfolder(fullfile(radial_dat, strcat("t_", num2str(t))))
            mkdir(fullfile(radial_dat, strcat("t_", num2str(t))))
        end
        if ~isfolder(fullfile(circum_dat, strcat("t_", num2str(t))))
            mkdir(fullfile(circum_dat, strcat("t_", num2str(t))))
        end
        if ~isfolder(fullfile(long_dat, strcat("t_", num2str(t))))
            mkdir(fullfile(long_dat, strcat("t_", num2str(t))))
        end
        if ~isfolder(fullfile(rad_circ_dat, strcat("t_", num2str(t))))
            mkdir(fullfile(rad_circ_dat, strcat("t_", num2str(t))))
        end
        if ~isfolder(fullfile(circ_long_dat, strcat("t_", num2str(t))))
            mkdir(fullfile(circ_long_dat, strcat("t_", num2str(t))))
        end
        if ~isfolder(fullfile(rad_long_dat, strcat("t_", num2str(t))))
            mkdir(fullfile(rad_long_dat, strcat("t_", num2str(t))))
        end
        if ~isfolder(fullfile(D_x_dat, strcat("t_", num2str(t))))
            mkdir(fullfile(D_x_dat, strcat("t_", num2str(t))))
        end
        if ~isfolder(fullfile(D_y_dat, strcat("t_", num2str(t))))
            mkdir(fullfile(D_y_dat, strcat("t_", num2str(t))))
        end
        if ~isfolder(fullfile(D_z_dat, strcat("t_", num2str(t))))
            mkdir(fullfile(D_z_dat, strcat("t_", num2str(t))))
        end

        if ~isempty(strain(:,:,z))
            writematrix(strain(:,:,z,1,1),fullfile(radial_dat, fullfile(strcat("t_", num2str(t)), strcat(study, "_radial_strain_", num2str(z), ".dat"))));
            writematrix(strain(:,:,z,2,2),fullfile(circum_dat, fullfile(strcat("t_", num2str(t)), strcat(study, "_circum_strain_", num2str(z), ".dat"))));
            writematrix(strain(:,:,z,3,3),fullfile(long_dat, fullfile(strcat("t_", num2str(t)), strcat(study, "_long_strain_", num2str(z), ".dat"))));
            writematrix(strain(:,:,z,1,2),fullfile(rad_circ_dat, fullfile(strcat("t_", num2str(t)), strcat(study, "_rc_shear_strain_", num2str(z), ".dat"))));
            writematrix(strain(:,:,z,2,3),fullfile(circ_long_dat, fullfile(strcat("t_", num2str(t)), strcat(study, "_cl_shear_strain_", num2str(z), ".dat"))));
            writematrix(strain(:,:,z,1,3),fullfile(rad_long_dat, fullfile(strcat("t_", num2str(t)), strcat(study, "_rl_shear_strain_", num2str(z), ".dat"))));
            writematrix(disp(:,:,z,1,1),fullfile(D_x_dat, fullfile(strcat("t_", num2str(t)), strcat(study, "_D_x_", num2str(z), ".dat"))));
            writematrix(disp(:,:,z,1,2),fullfile(D_y_dat, fullfile(strcat("t_", num2str(t)), strcat(study, "_D_y_", num2str(z), ".dat"))));
            writematrix(disp(:,:,z,1,3),fullfile(D_z_dat, fullfile(strcat("t_", num2str(t)), strcat(study, "_D_z_", num2str(z), ".dat"))));
            %         writematrix(disp(:,:,z,3),fullfile(roi_dat, fullfile(strcat("t_", num2str(t)), strcat(study, "_D_z_", num2str(z), ".dat"))));
        end
    end
end