function contours=contour_reader(filename)
%%
% 1: Count number of points for each slice
% 2: For each slice how many timepoints we have?
% 3: Make the new data structure & How many of these timepoints are empty? (no data) replace 0 w/ NaN
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
% read the file
contour_data= dlmread(filename,delim, 4,0);
%%
% Step 1: count the No. of points in each slice
slice_info(:,1) = unique(contour_data(:,1)); % slice no.
slice_info(:,2) = histc(contour_data(:,1), slice_info(:,1)); %no. of points per slice 
%% Step 2
timepoints_max=(size(contour_data,2)-1)/2;
%% Step 3 
for ii=1:size(slice_info,1)
    for tt=1:timepoints_max
        contours{slice_info(ii,1), tt}(:,1:2)=contour_data(sum(slice_info(1:ii-1,2))+1:sum(slice_info(1:ii,2)),2*tt:2*tt+1);
        contours{slice_info(ii,1), tt}(:,3)=slice_info(ii,1);
        if(~all(contours{slice_info(ii,1), tt}(:,1)))
            contours{slice_info(ii,1), tt}=[];
        end
    end
end
%%  