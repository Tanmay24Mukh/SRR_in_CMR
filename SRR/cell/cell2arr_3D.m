function arr_3D = cell2arr_3D(acell)
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
% Developed by MK on 2021_11_20
% Last rev by MK on 2022_01_20
%
%======> This is a work in progress.
%%
cell_dims = size(acell);
arr_2D_dims = size(acell{1,1});

arr_3D_dims = [arr_2D_dims cell_dims(1)];


arr_3D = reshape([acell{:}],arr_3D_dims);


end