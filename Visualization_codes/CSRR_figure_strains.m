function CSRR_figure_strains(flid, slice)
out = 'strains';
Figures = dir(fullfile(flid,"Figures",out)); New = true;
Figures = Figures(cellfun(@(x)isequal(x,New),({Figures.isdir})) & cellfun(@(x)isequal(x,"NEW"),({Figures.name})));
Figures = dir(fullfile(Figures.folder, Figures.name, "03"));
if slice == "y"
    Figures = Figures(cellfun(@(x)max(ismember(split(x,"_"),"slice")),{Figures.name}));
else
    Figures = Figures(~cellfun(@(x)max(ismember(split(x,"_"),"slice")),{Figures.name}));
end
for i = 1:size(Figures)
    A = split(Figures(i).name,["_","."]);
    if (max(ismember(A,"fig")) == 1) && (str2double(A(end-1)) < 10)
        openfig(fullfile(Figures(i).folder,Figures(i).name));
        axes = findall(gcf,'type','axes','tag','');
        [axes(:).CLim] = deal([-0.5, 0.5]);
    end
end
end