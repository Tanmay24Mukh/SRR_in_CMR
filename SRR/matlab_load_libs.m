function mfile_dirs = matlab_load_libs(matlab_libs_array)
%%
%======> This is a work in progress.
%
%======> matlab_load_libs:
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
% Developed by MK on 2021_12_06
% Last rev by MK on 2021_12_20
%
%======> This is a work in progress.
%%

for ii=1:size(matlab_libs_array,1)
    mfile_dirs_root = matlab_libs_array{ii,1};
    matlab_libs = matlab_libs_array{ii,2};
    
    mfile_dirs = cellfun(@(x) fullfile(mfile_dirs_root,x), matlab_libs,'UniformOutput',false);

    addpath(mfile_dirs{:})
end


end