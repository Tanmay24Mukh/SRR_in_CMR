% clear all;
% clc;


% study='M4539_1'; % HXX -> Human, MXX/MXXX -> Mouse
% UTSW = true;
% month = 'aug_sept_2022';
% 
% dir.mfile_libraries_root= 'C:\Users\tanmaymu\Documents\C2BL\Repos\CMR\';
% dir.root='C:\Users\tanmaymu\Documents\C2BL\';

study = "Orthogonal";
dataset = "D:\CSRR\Datasets\Validation\results\Orthogonal\";
% results_sr = load(fullfile(dataset, "Images_sr_Orthogonal_resample_L_0.5_W_0.5_H_0.1_linear.mat"));

dat_file = fullfile(dataset,"dat_files");
rs = results_sr.images_SR.pvals.gray;
loglist = cellfun(@isempty,rs);
t_end = size(loglist(loglist== false),2);

if ~isfolder(dat_file)
    mkdir(dat_file);
end


sr_dat = fullfile(dat_file,"images_sr"); 

if ~isfolder(sr_dat)
    mkdir(sr_dat);
end


% for t = 1:t_end
for t = 1:size(rs,2)
    for z = 1:size(rs,1)
            pvals = rs{z,t};
        if ~isfolder(fullfile(sr_dat, strcat("t_", num2str(t))))
            mkdir(fullfile(sr_dat, strcat("t_", num2str(t))))
        end

        if ~isempty(pvals)
            writematrix(pvals,fullfile(sr_dat, fullfile(strcat("t_", num2str(t)), strcat(study, "_images_sr_", num2str(z), ".dat"))));
        end
    end
end