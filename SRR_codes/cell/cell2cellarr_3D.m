function cell_1D = cell2cellarr_3D(acell)
%%
%======> This is a work in progress.
%
%======> cell2arr_3D:
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
% Developed by MK on 2022_01_21
% Last rev by MK on 2022_01_21
%
%======> This is a work in progress.
%%
cell_dims = size(acell);
arr_2D_dims = size(acell{1,1});

cell_1D = cell(1,cell_dims(2));
arr_3D_dims = [arr_2D_dims cell_dims(1)];

for ii=1:cell_dims(2)
    cell_1D{ii} = reshape([acell{:,ii}],arr_3D_dims);
end



end