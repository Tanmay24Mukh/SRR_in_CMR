% Define the range for x and y coordinates
x = -5:0.1:5;
y = -5:0.1:5;

% Create a meshgrid for x and y
% [X, Y] = meshgrid(x, y);

X = results_iso.images_iso.RCS.X{100,1};
Y = results_iso.images_iso.RCS.Y{100,1};

% Define the z positions for the grids
z_positions = [0, 2, 4];

% Create figure
figure;
hold on;

% Plot grids at different z positions
for z = z_positions
    Z = z * ones(size(X));
    plot3(X, Y, Z, 'b'); % You can use 'b' to specify the color, adjust as needed
end

% Customize the plot
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
title('Multiple Grids at Different Z Positions');

% Add a legend
legend('Grid at Z=0', 'Grid at Z=2', 'Grid at Z=4');

% Hold off to prevent further additions to the plot
hold off;

% Adjust view and aspect ratio
view(3);
axis equal;