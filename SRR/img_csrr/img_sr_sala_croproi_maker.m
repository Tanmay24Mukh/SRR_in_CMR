function crop_ROI_SR = img_sr_sala_croproi_maker(crop_ROI_SA,crop_ROI_LA,index_SA,index_LA,index_SA_used, index_LA_used, img_size)
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
% Last rev by MK on 2021_12_23
%
%======> This is a work in progress.
%%
crop_ROI_SR = cell(img_size);
k_counter=0;

for tt=1:img_size(2)
    for kk = index_SA
        k_counter=k_counter+1;
        if k_counter<=crop_ROI_SA(3,1) || k_counter>length(index_SA)-crop_ROI_SA(3,2) || ~any(kk==index_SA_used)
            crop_ROI_SR{kk,tt}=nan;
        else
            crop_ROI_SR{kk,tt}=crop_ROI_SA(1:2,1:2);
        end
    end
    k_counter=0;
end

k_counter=0;
for tt=1:img_size(2)
    for kk = index_LA
        k_counter=k_counter+1;
        if k_counter<=crop_ROI_LA(3,1) || k_counter>length(index_LA)-crop_ROI_LA(3,2) || ~any(kk==index_LA_used)
            crop_ROI_SR{kk,tt}=nan;
        else 
            crop_ROI_SR{kk,tt}=crop_ROI_LA(1:2,1:2);
        end
    end
    k_counter=0;
end
