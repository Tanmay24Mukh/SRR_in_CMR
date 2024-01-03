function ROIs = img_get_points_in_rois(roi_ids, mask , X, Y, Z, X_chull, Y_chull, Z_chull)
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
% Developed by MK on 2021_12_13
% Last rev by MK on 2021_12_24
%
%======> This is a work in progress.
%%
roi_id_indices = cell(length(roi_ids));
inhull_indices = cell(length(roi_ids));
ROIs = cell(length(roi_ids)+1,1);


for roi_id=roi_ids
    roi_id_indices{roi_id} = find(mask==roi_id); %find the roi's indices

    xyz_hull=[X_chull(roi_id_indices{roi_id}),Y_chull(roi_id_indices{roi_id}),Z_chull(roi_id_indices{roi_id})];
    
    inhull_indices{roi_id} = inhull([X(:),Y(:),Z(:)], xyz_hull);
end
roi_sums = sum(double(cat(2, inhull_indices{:})),2);

for roi_id = roi_ids
    ROIs{roi_id, 1} = find(roi_sums == roi_id & inhull_indices{roi_id}==1);
end
    
ROIs{length(roi_ids)+1,1} = find(roi_sums==0); %nans

end