function contours_cart_resampled = contour_refinery(contours,resample_ratio,count_slices)
%%
%======>contour_refinery:
%
%       INPUTS:
%               contours
%               resample_ratio
%               count_slices
%               
%
%
%       OUTPUTS:
%               contour_ref
%======
% Developed by MK on 2020_12_13
% Last rev by MK on 2021_12_04
%
%======> This is a work in progress.
%%
contours_polar_I=cell(size(contours));

for tt=1:size(contours,2)
    contours_polar_circ=[];


    counter=0;
    range_Z(1)=find(~cellfun(@isempty,contours(:,tt)),1);
    range_Z(2)=find(~cellfun(@isempty,contours(:,tt)),1,'last');


    division_count=[size(contours{range_Z(1),1},1) (range_Z(2)-range_Z(1))*1/resample_ratio(3)];

    %=======>1. Calculate the center for the polar coords at each timepoint
    % reshape the contour coords
    coords_cart_all = reshape([contours{:,tt}],size(contours{range_Z(1),tt},1),3,[]);% Format => [x,y,z]
    xyz_cart_center = nanmean(nanmean(coords_cart_all,1),3); %Calculate the mean of all coords at each timepoint

    %=======>2. transfer to polar coords and Sort the coords
    phi=-pi:2*pi/division_count(1):pi;
    phi=phi(1:end-1);

    for kk=1:size(contours,1)
        coords_polar_Usorted=[]; % Coords in polar unsorted
        coords_polar=[]; % Coords in polar

        if (~isempty(contours{kk,tt}) && ~isnan(contours{kk,tt}(1,1)))


            counter=counter+1;
            %=====Calculate the polar coord
            coords_cart_new=contours{kk,tt}(:,1:2)-xyz_cart_center(1,1:2); %Coords in Cartesian
            [coords_polar(:,1), coords_polar(:,2)] = cart2pol(coords_cart_new(:,2),coords_cart_new(:,1)); %theta & r
            coords_polar(:,3)=contours{kk,tt}(:,3); %z

            %=====Remove repetitions & sort
            [C,ia,ic]=unique(coords_polar(:,1)); %Default is sorted
            coords_polar_Usorted(:,1)=coords_polar(ia,1);
            coords_polar_Usorted(:,2)=coords_polar(ia,2);
            coords_polar_Usorted(:,3)=coords_polar(ia,3);
            %=====

            coords_polar_sorted=coords_polar_Usorted(:,1)-phi(1);

            %=====Resample at each z position along theta
            %--Note coord is still polar
            contours_polar_I{kk,tt}(:,1)=phi;
            contours_polar_I{kk,tt}(:,2)=interp1(coords_polar_Usorted(:,1),coords_polar_Usorted(:,2),phi','pchip');
            contours_polar_I{kk,tt}(:,3)=coords_polar_Usorted(1,3);
        else
            contours_polar_I{kk,tt}=nan;
        end

    end

    %=====Plots for quality testing :)
    %     figure();
    %     plot(coords_P_Usorted(:,1),coords_P_Usorted(:,2),'o',phi',coords_P_US_resampled(:,2),':.');

    %=====Resampling in the z direction & changing back to global cartesian
    contours_polar_circ=reshape([contours_polar_I{range_Z(1):range_Z(2),tt}],...
        size(contours_polar_I{range_Z(1),tt},1),...
        size(contours_polar_I{range_Z(1),tt},2),counter); %

    %resample_ratio(3)=(range_Z(2)-range_Z(1))/(division_count(2)-1);
    %division_count(2)=(counter-1)*1/resample_ratio(3)+1;


    %==1
    %zz=min(dd(1,3,:)):(max(dd(1,3,:))-min(dd(1,3,:)))/(division_count(2)-1):max(dd(1,3,:));
    %==2
    %zz=min(dd(1,3,:)):resample_ratio(3):max(dd(1,3,:));
    %==3



    z_resampled = ...
        range_Z(1)-0.5 + resample_ratio(3)/2:...
        resample_ratio(3):...
        range_Z(2)+0.5-resample_ratio(3)/2;

    z_exp_count_top = length(min(range_Z(1), z_resampled(1)):resample_ratio(3):max(range_Z(1), z_resampled(1)))-1;
    z_exp_count_bottom = length(min(range_Z(2), z_resampled(end)):resample_ratio(3):max(range_Z(2), z_resampled(end)))-1;

    %     z_count_bottom = abs(1-z_resampled(1))./resample_ratio(3)-1+0.5;
    z_count_bottom = length(range_Z(2):resample_ratio(3):z_resampled(end));
    z_count_top = length(min([1, z_resampled(1)]):resample_ratio(3):max([1, z_resampled(1)]));

    ave_region=floor(1./resample_ratio(3)*1);

    %zz_1=1:(max(dd(1,3,:))-min(dd(1,3,:)))/(ratios(2)-1):min(dd(1,3,:));
    %zz_1=zz_1(1:end-1)
    %%
    coords_resampled_Z=[];

    for ii=1:size(contours_polar_I{range_Z(1),tt},1) %loop over theta
        coords_resampled_Z(:,3) = z_resampled;
        coords_resampled_Z(:,2) = interp1(squeeze(contours_polar_circ(ii,3,:)),squeeze(contours_polar_circ(ii,2,:)),z_resampled','pchip','extrap'); %rho
        coords_resampled_Z(:,1) = contours_polar_circ(ii,1,1); %theta


        for kk = 1:length(z_resampled)
            %idx=(range_Z(1)-1)*1/resample_ratio(3)+kk;

            idx=floor(z_count_top+kk);

                contours_cart_resampled{idx,tt}(ii,3)=z_resampled(kk);
                [contours_cart_resampled{idx,tt}(ii,2), contours_cart_resampled{idx,tt}(ii,1)]=pol2cart(coords_resampled_Z(kk,1),coords_resampled_Z(kk,2));
                contours_cart_resampled{idx,tt}(ii,1:2)=contours_cart_resampled{idx,tt}(ii,1:2)+xyz_cart_center(1,1:2);

        end
        if(idx<count_slices)
            for kk=idx+1:count_slices
                contours_cart_resampled{kk,tt}(ii,1:3)=nan ;
            end
        end
    end



end

end