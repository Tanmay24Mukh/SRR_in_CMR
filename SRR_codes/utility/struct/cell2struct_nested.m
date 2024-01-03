function mystruct = cell2struct_nested(acell)
%%
% Generates struct from nested cells (recursively)
%======> INPUTS:
%        acell: nested cell array of form {{a,{a1,a2}},{b,{b1,b2,b3}},...}
%
%======> OUTPUTS:
%        mystruct: struct built from nested cell array
%======
% Developed by MK on 2021_12_03
% Last rev by MK on 2021_12_04
%%
acell_size=size(acell);
acell_new = cell(2,acell_size(2));

for jj = 1:acell_size(2)
    
    r1_iscell = iscell(acell{1,jj});
    r1_isstruct = isstruct(acell{1,jj});
    r1_ischar = ischar(acell{1,jj});
    
    if r1_iscell && ~r1_isstruct
        r_size = size(acell{:,jj});
        if r_size(1)>1
            acell_new{1,jj} = acell{1,jj}{1};
            acell_new{2,jj} = cell2struct_nested([acell{1,jj}{2}]);
        end
    elseif r1_ischar
        r_size = size(acell(:,jj));
        acell{1,jj};
        if r_size(1) == 1
            acell_new{1,jj} = acell{1,jj};
            acell_new{2,jj} = {{}};
        else
            acell_new{1,jj} = acell{1,jj};
            acell_new{2,jj} = cell2struct_nested(acell{2,jj});
        end
        
    end
    
end

mystruct=struct(acell_new{:});

end