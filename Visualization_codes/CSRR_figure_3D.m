function CSRR_figure_3D(flid, vol, resolution)
out = "3D";
Figures = dir(fullfile(flid,"Figures",out));
if vol == "pc"
    if resolution ~= "HR" || resolution ~= "LR"
        resolution = "HR";
    end
    Figures = Figures(cellfun(@(x)max(ismember(split(x,"_"),["pc", resolution])),{Figures.name}));
else
    Figures = Figures(cellfun(@(x)max(ismember(split(x,"_"),resolution)),{Figures.name}) & ...
        ~cellfun(@(x)max(ismember(split(x,"_"),"pc")),{Figures.name}));
end
for i = 1:size(Figures)
    A = split(Figures(i).name,["_","."]);
    if max(ismember(A,"fig")) == 1
        figi = fullfile(Figures(i).folder,Figures(i).name);
        openfig(figi);
    end
end
end