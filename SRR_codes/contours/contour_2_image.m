function cntr_img = contour_2_image(filename_inner, filename_outer, img_dim, pixel_dim, crop_ROI, resample_ratio,  varargin)
%%
%======> This is a work in progress.
%
%======> contour_2_image:
%
%           INPUTS:
%                   filename_inner
%                   filename_outer
%                   img_dim
%                   pixel_dim
%                   crop_ROI
%                   resample_ratio
%                   
%
%           OUTPUTS:
%
%
%
%
%======
% Developed by MK on 2020_12_XX
% Last rev by MK on 2022_01_10
%
%======> This is a work in progress.
%%
%% parse arguments
p = inputParser;
addOptional(p, 'cntrs_used', @islogical);
parse(p, varargin{:});
cntrs_used = p.Results.cntrs_used;


%%
temp.inner=contour_reader(filename_inner);
temp_inner_size = size(temp.inner);
temp.outer=contour_reader(filename_outer);
temp_outer_size  = size(temp.outer);

cntr_count = max([temp_inner_size(1), temp_inner_size(1), length(cntrs_used)]);

contours.inner=cell(cntr_count, temp_inner_size(2));
contours.outer=cell(cntr_count, temp_inner_size(2));

contours.inner(1:temp_inner_size(1),:)=temp.inner;
contours.outer(1:temp_outer_size(1),:)=temp.outer;

if isempty(cntrs_used)
    cntrs_used=true(size(contours.inner,1));
end
% resample_ratio(3) = sum(cntrs_used)/length(cntrs_used)*resample_ratio(3)
%%
%=====

count_slices=img_dim(3);%max(size(contours.inner_F,1), size(contours.outer_F,1))
if(size(img_dim,2)==3)
    %divisions_count=[size(contours.inner{range_Z(1),1},1) (range_Z(2)-range_Z(1))*1/resample_ratio(3)+1]; %1 value for the XY plane and 1 for Z dir
    contours.inner_F = contour_refinery(contours.inner(cntrs_used,:), resample_ratio, count_slices);
    contours.outer_F = contour_refinery(contours.outer(cntrs_used,:), resample_ratio, count_slices);
else
    divisions_count=[size(contours.inner{1,1},1) 1];
    contours.inner_F=contours.inner;
    contours.outer_F=contours.outer;
end
%%
%=====
count_timepoints=size(contours.inner,2);

%%
%=====generate the query points
x=1:1:img_dim(1); %rows are in y direction and columns in the x
y=1:1:img_dim(2);
qq=1;
for ii=x
    for jj=y
        coord_q(qq,1:2)=[ii,jj];
        qq=qq+1;
    end
end
%%
%=====
for tt=1:count_timepoints
    cntr_img{tt}=nan(img_dim);   
    
    %img_o{tt}=zeros(img_Dim(1), img_Dim(2),count_slices);
    
    for kk=1:count_slices
        
        contour_inner=contours.inner_F{kk,tt};
        contour_outer=contours.outer_F{kk,tt};
        %slice_position=contours.inner_F{kk,tt}(1,3);
        
        if (isempty(contour_inner) && isempty(contour_outer))
            %img{tt}(:,:,kk)=zeros(img_dim); %nothing will be included
            
        elseif(isempty(contour_inner) && ~isempty(contour_outer))
            contour_outer_t(:,1)=(contour_outer(:,1)/pixel_dim(1)-crop_ROI(1,1)-0.5)/resample_ratio(1);
            contour_outer_t(:,2)=(contour_outer(:,2)/pixel_dim(2)-crop_ROI(2,1)-0.5)/resample_ratio(2); 
            
            in_outer = inpolygon(coord_q(:,2),coord_q(:,1),contour_outer_t(:,2),contour_outer_t(:,1));
            
            ROIs=...
                (...
                reshape(double(in_outer),img_dim(2),img_dim(1)))';
            ROIs(ROIs==0)=nan;
            cntr_img{tt}(:,:,kk)=ROIs;%(range_Z(1)-1)*1/resample_ratio(3)+kk
            
            
        elseif(~isempty(contour_inner) && ~isempty(contour_outer))
            contour_inner_t(:,1)=(contour_inner(:,1)/pixel_dim(1)-crop_ROI(1,1)-0.5)/resample_ratio(1); % transfer/scale coordinates
            contour_inner_t(:,2)=(contour_inner(:,2)/pixel_dim(2)-crop_ROI(2,1)-0.5)/resample_ratio(2);
                
            contour_outer_t(:,1)=(contour_outer(:,1)/pixel_dim(1)-crop_ROI(1,1)-0.5)/resample_ratio(1);
            contour_outer_t(:,2)=(contour_outer(:,2)/pixel_dim(2)-crop_ROI(2,1)-0.5)/resample_ratio(2);
            %%
            
            in_inner = inpolygon(coord_q(:,2),coord_q(:,1),contour_inner_t(:,2),contour_inner_t(:,1));
            in_outer = inpolygon(coord_q(:,2),coord_q(:,1),contour_outer_t(:,2),contour_outer_t(:,1));
            %%
            %=====Multiple approaches for selection:
%             %=====1st logical: just b/w the contours
%             inside= double(~in_inner & in_outer); %points that are b/w the contours
%             inside(inside==0)=nan;
%             img{tt}(:,:,kk)=reshape(inside,img_Dim(2),img_Dim(1))';
            %=====2nd: in_inner=2, only in_outer 1, ... surrounding Nan
            ROIs=...
                (reshape(double(in_inner),img_dim(2),img_dim(1))+...
                reshape(double(in_outer),img_dim(2),img_dim(1)))';
            ROIs(ROIs==0)=nan;
            cntr_img{tt}(:,:,kk)=ROIs;%(range_Z(1)-1)*1/resample_ratio(3)+kk
            
            
        end        
    end
%     img{tt}=round(img_process_resample(img_o{tt},[1 1 resample_ratio(3)]));
end

end