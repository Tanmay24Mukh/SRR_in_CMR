close all;
clc;

%% Dataset
study = "M202";
scan_no = "S02"; % S01 radial S02 Orthogonal
dataset = "D:\CSRR\Datasets\M202";
dataset = fullfile(dataset,strcat(study,"_",scan_no),"results");


%% Result Parameters
linear = 'n'; 
LA = 1.0; I = 0.5; C = 0.25; H = 0.50;

%% Figure Requirements
out = "3D"; % strains, 2D or 3D
slice = "y";
vol = "nopc"; % pc or nopc
resolution3D = "LRvHR"; % LR, HR or LRvHR
axis = "LA"; % LA or SA or comp
resolution2D = "super"; % O or super

%%
if linear == 'y'
    results = fullfile(dataset, strcat("SA_1.0", "_LA_", num2str(LA,'%.1f'), ...
        "_linear", "_I_", num2str(I,'%.2f'),"_C_", ...
        num2str(C,'%.2f'), "_H_", num2str(0.5, '%.2f'),"_X00"));
else
    results = fullfile(dataset, strcat("SA_1.0", "_LA_", num2str(LA,'%.1f'), ...
        "_natural", "_I_", num2str(I,'%.2f'),"_C_", ...
        num2str(C,'%.2f'), "_H_", num2str(0.5, '%.2f'),"_X00"));
end

%%
if out == "strains"
    CSRR_figure_strains(results, slice)
elseif out == "3D"
    CSRR_figure_3D(results,vol,resolution3D)
elseif out == "2D"
    CSRR_figure_2D(results,axis,resolution2D)
end

%     set(0,'DefaultFigureWindowStyle','docked')



