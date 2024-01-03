function mystruct = args2struct_nested(args)
%%
% Generates struct from nested cells (recursively)
%======> INPUTS:
%        args: nested cell array ([{arg1,arg2;{{arg3;{{}}},{}}}])
%
%======> OUTPUTS:
%        mystruct: struct built from nested cell array    
%======
% Developed by MK on 2021_12_03
% Last rev by MK on 2021_12_03
%%
args_size=size(args);
args_new = cell(size(args));

if iscell(args)
    for ii=1:args_size(2)
        if size(args(:,ii))==1%isempty(args(2,ii))
            args_new{1,ii} = args{1,ii};
            args_new{2,ii}={{}};
        else
            args_new{1,ii}=args{1,ii};
            args_new{2,ii} = args2struct_nested(args{2,ii});
        end
    end
    
    mystruct=struct(args_new{:});
    
end
%%
end