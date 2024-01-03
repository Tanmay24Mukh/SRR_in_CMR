function [pvals, map, info]=dicom_read_2_4D(dir_input)
%%
%======> This is a work in progress.
%
%======> :
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
% Developed by MK on 2020_12_03
% Last rev by MK on 2021_12_04
%
%======> This is a work in progress.
%%

% Get a list of all files and folders in this folder.
files = dir(dir_input);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);
% Print folder names to command window.
subFolders = subFolders(~ismember({subFolders(:).name},{'.','..'}));


for (kk=1:length(subFolders))
    
    img_dicom_list=dir(fullfile(subFolders(kk).folder,subFolders(kk).name, '*.dcm'));
    for(tt=1:length(img_dicom_list))
        temP_filename=fullfile(img_dicom_list(kk).folder, img_dicom_list(tt).name);
        [pvals{kk,tt}, map{kk,tt}]=dicomread(temP_filename);
        info{kk,tt}=dicominfo(temP_filename);
        
    end    
end
