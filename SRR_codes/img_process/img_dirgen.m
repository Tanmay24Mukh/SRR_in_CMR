function [study_ids, dirs, filenames, files]=img_dirgen(study_ids, dirs, filenames, matlab_libs)
%%
%======> This is a work in progress.
%           generates the dir, filenames, and files for a given dataset
%======> img_dirgen:
%
%           INPUTS:
%
%
%
%           OUTPUTS:
%
%
%
%
%======
% Developed by MK on 2021_11_29
% Last rev. by MK on 2022_01_24
%
%======> This is a work in progress.
%%
dir_dontmakelist={'mfile_libraries_root' , 'mfile_libraries'};
%========
f_names=fieldnames(filenames);
d_names=fieldnames(dirs);
%%
%========Load additional MATLAB libraries
if any(cell2mat(cellfun(@(x) strcmp(x,dir_dontmakelist{1}), d_names,'UniformOutput',false))) && ...
        any(cell2mat(cellfun(@(x) strcmp(x,dir_dontmakelist{2}), d_names,'UniformOutput',false)))
    dirs.mfile_libraries(length(dirs.mfile_libraries)+1:length(dirs.mfile_libraries)+length(matlab_libs)) = ...
        cellfun(@(x) fullfile(dirs.mfile_libraries_root,x), matlab_libs,'UniformOutput',false);

    addpath(dirs.mfile_libraries{:});
end
%%
%=======
study_ids.study_name=strcat(study_ids.patient,'_',study_ids.scan);
study_ids.CSRR_study=strcat(study_ids.images_used,'_',study_ids.param_id);
%%
study_ids.ID = [study_ids.study_name,'_',study_ids.CSRR_study];

%%
%========Make the dataset dir
dirs.datasets=fullfile(dirs.project_root,'Datasets');

dirs.patient=fullfile(dirs.datasets,study_ids.patient);

dirs.scan=fullfile(dirs.patient,study_ids.study_name);
%%
%========Set contour dir & filenames
dirs.contours=fullfile(dirs.scan,'contours');
filenames.contours.SA.LV.prefix=strcat(study_ids.study_name,'_SA_LV');
filenames.contours.SA.LV.endo=[filenames.contours.SA.LV.prefix '_Endo.csv'];
filenames.contours.SA.LV.epi=[filenames.contours.SA.LV.prefix '_Epi.csv'];


files.contours.SA.LV.endo=fullfile(dirs.contours, filenames.contours.SA.LV.endo);
files.contours.SA.LV.epi=fullfile(dirs.contours, filenames.contours.SA.LV.epi);

filenames.contours.LA.LV.prefix=strcat(study_ids.study_name,'_LA_LV');
filenames.contours.LA.LV.endo=[filenames.contours.LA.LV.prefix '_Endo.csv'];
filenames.contours.LA.LV.epi=[filenames.contours.LA.LV.prefix '_Epi.csv'];

files.contours.LA.LV.endo=fullfile(dirs.contours, filenames.contours.LA.LV.endo);
files.contours.LA.LV.epi=fullfile(dirs.contours, filenames.contours.LA.LV.epi);
%%
%========dicom files
dirs.images = fullfile(dirs.scan,'img');

dirs.images_original = fullfile(dirs.images ,strcat(study_ids.study_name,'_img_dicom_Original'));
dirs.images_sorted = fullfile(dirs.images ,strcat(study_ids.study_name,'_img_dicom_Sorted'));

% images = img_readDicom_4D(dirs.input_dicom);
%%
%========Set output dir
dirs.results = fullfile(dirs.scan,'results');

dirs.results__study = fullfile(dirs.results,study_ids.CSRR_study);

% make the folders for

%========Set figure dir
dirs.results_figures = fullfile(dirs.results__study,'Figures');


if any(cell2mat(cellfun(@(x) strcmp(x,'outputs'), f_names,'UniformOutput',false)))
    %results
    output_names = fieldnames(filenames.outputs);

    if any(cell2mat(cellfun(@(x) strcmp(x,'results'), output_names,'UniformOutput',false)))
        files.outputs.results = make_files(dirs.results__study, study_ids.ID, filenames.outputs.results);
    end
    %images
    if any(cell2mat(cellfun(@(x) strcmp(x,'images'), output_names,'UniformOutput',false)))
        files.outputs.images = make_files(dirs.results__study, study_ids.ID, filenames.outputs.images);
    end

end
%%
%======== make the dirs
dir_names=fieldnames(dirs);

for ii = 1:length(dir_names)
    if all(cell2mat(cellfun(@(x) ~strcmp(x,dir_names{ii}), dir_dontmakelist,'UniformOutput',false)))
        if ~isfolder(dirs.(dir_names{ii}))
            mkdir(dirs.(dir_names{ii}))

        end
    end
end
%%
%========

end
