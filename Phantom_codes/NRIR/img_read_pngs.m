function images = img_read_pngs(image_dataset)

files = dir(image_dataset);
dirFlags = [files.isdir];
subFolders = files(dirFlags);
subFolders = subFolders(~ismember({subFolders(:).name},{'.','..'}));

for (kk=1:length(subFolders))
    img_list = dir(fullfile(subFolders(kk).folder,subFolders(kk).name));
    img_list = img_list(cellfun(@(x)~isequal(x,true),{img_list.isdir}));
    
    for(tt=1:length(img_list))
        temP_filename=fullfile(img_list(tt).folder, img_list(tt).name);
        [images.img{kk,tt}, images.map{kk,tt}]=imread(temP_filename);
        images.info{kk,tt}=imfinfo(temP_filename);    
    end   
end

end