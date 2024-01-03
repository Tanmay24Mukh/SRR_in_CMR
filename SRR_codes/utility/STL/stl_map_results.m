function [object, colors_new, gray_zone]=stl_map_results(values, img_size, vertices, faces)

x=1:1:img_size(1);
y=1:1:img_size(2);
z=1:1:img_size(3);

colors_new = zeros(size(vertices,1),1);
gray_zone=[];

for ii=1:size(vertices,1)

    coord=vertices(ii,:);
    [d, ix] = min(abs(x-coord(1,1)));
    [~, iy] = min(abs(y-coord(1,2)));
    [d, iz] = min(abs(z-coord(1,3)));
    
    if isnan(values(ix,iy,iz))
        gray_zone(end+1)=ii;
    else
     colors_new(ii,:)=values(ix,iy,iz);
    end
end

object=[];
object.vertices=vertices;
object.faces=faces;

end