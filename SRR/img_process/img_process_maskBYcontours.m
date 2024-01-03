function array_masked=img_process_maskBYcontours(array,filename_inner,filename_outer,mm2pixel,crop_ROI,resample_ratio)
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
% Developed by MK on 2020_12_13
% Last rev by MK on 2021_12_04
%
%======> This is a work in progress.
%%
delim=',';
%%
contours.inner= dlmread(filename_inner,delim, 4,0);
contours.outer= dlmread(filename_outer,delim, 4,0);

count_timepoints=length(array);
%%
for (tt=1:1:count_timepoints)
    for(kk=1:1:size(array{tt},3))
        if(length(size(array{1}))==4)
            [array_masked{tt}(:,:,kk,1),in_endo{tt},in_epi{tt}]=img_process_mask_dicom(array{tt}(:,:,kk,1),contours.inner(:,2*tt:2*tt+1), contours.outer(:,2*tt:2*tt+1),mm2pixel,crop_ROI,resample_ratio);
            [array_masked{tt}(:,:,kk,2),in_endo{tt},in_epi{tt}]=img_process_mask_dicom(array{tt}(:,:,kk,2),contours.inner(:,2*tt:2*tt+1), contours.outer(:,2*tt:2*tt+1),mm2pixel,crop_ROI,resample_ratio);
            [array_masked{tt}(:,:,kk,3),in_endo{tt},in_epi{tt}]=img_process_mask_dicom(array{tt}(:,:,kk,3),contours.inner(:,2*tt:2*tt+1), contours.outer(:,2*tt:2*tt+1),mm2pixel,crop_ROI,resample_ratio);
        elseif (length(size(array{1}))==3)
            [array_masked{tt}(:,:,1),in_endo{tt},in_epi{tt}]=img_process_mask_dicom(array{tt}(:,:,1),contours.inner(:,2*tt:2*tt+1), contours.outer(:,2*tt:2*tt+1),mm2pixel,crop_ROI,resample_ratio);
            [array_masked{tt}(:,:,2),in_endo{tt},in_epi{tt}]=img_process_mask_dicom(array{tt}(:,:,2),contours.inner(:,2*tt:2*tt+1), contours.outer(:,2*tt:2*tt+1),mm2pixel,crop_ROI,resample_ratio);
        end
    end
end

%%

end