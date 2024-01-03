% Create a sample cell array
m = 3; % Number of rows in the cell
n = 4; % Number of columns in the cell
i = 2; % Number of rows in each element array
j = 3; % Number of columns in each element array

cellArray = cell(m, n);
for row = 1:m
    for col = 1:n
        cellArray{row, col} = rand(i, j); % Example: Filling each element with a random i x j array
    end
end

% Convert cell array to a 1 x n cell array with concatenated arrays
concatenatedArray = cell(1, n);
for col = 1:n
    concatenatedArray{col} = cat(3, cellArray{:, col});
end
