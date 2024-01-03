function cellarr_1D = cell_2_cellarr_1D(mycell)
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
cell_1D = cellfun(@(x) x(:),mycell,'UniformOutput',false);
cellarr_1D=cell(1,size(mycell,2));

for tt=1:size(mycell,2)
    cellarr_1D{tt} = cat(1,cell_1D{:,tt});
end
end