function img_cropped=img_process_crop(img,ROI)
%% Boundaies are excluded

img_cropped=img(1+ROI(1,1):end-ROI(1,2),1+ROI(2,1):end-ROI(2,2),1+ROI(3,1):end-ROI(3,2));

end