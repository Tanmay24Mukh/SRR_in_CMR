function images = img_read_dicom_4D(image_dataset, t_last, t_skip)

files = dir(image_dataset);
dirFlags = [files.isdir];
subFolders = files(dirFlags);
subFolders = subFolders(~ismember({subFolders(:).name},{'.','..'}));

for (kk=1:length(subFolders))
    img_list = dir(fullfile(subFolders(kk).folder,subFolders(kk).name));
    img_list = img_list(cellfun(@(x)~isequal(x,true),{img_list.isdir}));
    count = 1;
    for(tt=1:t_skip:length(img_list))
        temP_filename=fullfile(img_list(tt).folder, img_list(tt).name);
        [images.img{kk,count}, images.map{kk,count}]=dicomread(temP_filename);
        images.info{kk,count}=dicominfo(temP_filename);    
        if tt>t_last
            break
        end
        count = count +1;
    end   
end

% images.info = images.info(cellfun(@(x) ~isempty(x(:)), images.info));

end