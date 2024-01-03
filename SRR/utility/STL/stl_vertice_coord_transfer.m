function vertices_new=stl_vertice_coord_transfer(vertices_old, pixelDim, crop_ROI, resample_ratio)

vertices_new=[];
vertices_new(:,1)=(vertices_old(:,1)/pixelDim(1)-crop_ROI(1,1)-0.5)/resample_ratio(1);
vertices_new(:,2)=(vertices_old(:,2)/pixelDim(2)-crop_ROI(2,1)-0.5)/resample_ratio(2);
vertices_new(:,3)=1+(vertices_old(:,3)-1)*10;

end