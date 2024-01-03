function arr_1D = cell2arr_1D(mycell)
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
arr_1D = cat(1,cell_1D{:});


end