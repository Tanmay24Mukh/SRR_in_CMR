function files = make_files(d, prefix, filenames)
% 
% 
%======>make_files:
%       XXX
%       
%       INPUTS:
%               
%               
%               
%       OUTPUTS:
%       
%======
% Developed by Maziyar Keshavarzian on 2021_11_11
% Last modification by Maziyar Keshavarzian on 2021_12_06
%%
files = cell(size(filenames));

for ii = 1:length(filenames)
    
    files{ii} = fullfile(d,...
        [prefix,'_', filenames{ii}]);
end
end