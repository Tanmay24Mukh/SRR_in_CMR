function file_list = get_filelist(path, extension)
%%
%======> This is a work in progress.
%
%======> get_filelist:
%
%           INPUTS:
%               path
%
%               extension
%
%
%           OUTPUTS:
%
%
%
%
%======
% Developed by MK on 2022_01_24
% Last rev by MK on 2022_01_24
%
%======> This is a work in progress.
%%
files = dir(fullfile(path, ['\**\*.' extension]));
dir_flags = [files.isdir];
files_real = files(~dir_flags);
files_real_count=length(files_real);

if extension == '*'
    folders = files(dir_flags);
    folders = folders(~ismember({folders(:).name},{'..','.'}));
    file_list=files_real;
    file_list(files_real_count+1:files_real_count+length(folders))=folders;
else
    file_list=files_real;    
end
%%
end
