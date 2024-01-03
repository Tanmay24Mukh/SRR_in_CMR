function sorted_struct=sort_struct(s,field)
%======>sort_struct:
%       sorts struct based on field
%
%======
% Developed by MK on 2020_11_29
% Last rev by MK on 2021_12_02
%%
T = struct2table(s); % convert the struct array to a table
sortedT = sortrows(T, field); % sort the table by field
sorted_struct = table2struct(sortedT); % change it back to struct array if necessary
end