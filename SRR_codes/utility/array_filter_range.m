function array_filtered=array_filter_range(array,range)
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
array_filtered=array;
for tt=1:length(array)
    mag=sqrt(array{tt}(:,:,:,1).^2+array{tt}(:,:,:,2).^2+array{tt}(:,:,:,3).^2);
    array_filtered{tt}(mag>range(2) | mag<range(1))=nan;
end
end