%%
%======> This is a work in progress.
%
%======> :
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
% Developed by MK on 2020_12_13
% Last rev by MK on 2020_12_24
%
%======> This is a work in progress.
%%
point = [60 60 40];

normal = [1 1 0];
V=squeeze(Ep{t_p}(:,:,:,3,3));
[B,x,y,z] = obliqueslice(V,point,normal);

fig = figure;
axes1 = axes('Parent',fig,'Position',[0.13 0.4 0.37 0.5]);
surf(x,y,z,B,'EdgeColor','None','HandleVisibility','off','Parent',axes1);
grid on
view([-62.6 13.8])
colormap(gray)
xlabel('x-axis')
ylabel('y-axis');
zlabel('z-axis');
title('Position of Slice in 3-D Coordinate Space')

hold on
plot3(point(1),point(2),point(3),'or','MarkerFaceColor','r');
plot3(normal(1),normal(2),normal(3),'ob','MarkerFaceColor','b');
hold off
legend('Point in the volume','Normal vector','Position',[0.15 0.2 0.3 0.08])



axes2 = axes('Parent',fig,'Position',[0.59 0.52 0.33 0.6]);
% imshow(B,[],'Parent',axes2)
surface(zeros(size(B)),B,'EdgeColor','none','Parent',axes2);
title('Output Slice in Image Plane')