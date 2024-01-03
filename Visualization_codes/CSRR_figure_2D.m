function CSRR_figure_2D(flid, axis, resolution)
out = "2D";
Figures = dir(fullfile(flid,"Figures",out));
if axis == "LA"
    if resolution == "O"
        Figures = Figures(cellfun(@(x)(sum(ismember(split(x,"_"),"LA")) > 1) && ...
            (sum(ismember(split(x,"_"),"O")) >= 1),{Figures.name}));
    elseif resolution == "super"
        Figures = Figures(cellfun(@(x)(sum(ismember(split(x,"_"),"LA")) > 1) && ...
            (sum(ismember(split(x,"_"),"O")) < 1),{Figures.name}));
    end
    
elseif axis == "SA"
    if resolution == "O"
        Figures = Figures(cellfun(@(x)(sum(ismember(split(x,"_"),"SA")) > 1) && ...
            (sum(ismember(split(x,"_"),"O")) >= 1),{Figures.name}));
    elseif resolution == "super"
        Figures = Figures(cellfun(@(x)(sum(ismember(split(x,"_"),"SA")) > 1) && ...
            (sum(ismember(split(x,"_"),"O")) < 1),{Figures.name}));
    end
elseif axis == "comp"
    Figures = Figures(cellfun(@(x)(sum(ismember(split(x,"_"),"SA")) == 1) && ...
        (sum(ismember(split(x,"_"),"LA")) == 1)&& ...
        (sum(ismember(split(x,"_"),"montage")) < 1),{Figures.name}));
    
end


for i = 1:size(Figures)
    A = split(Figures(i).name,["_","."]);
    if A(end) == "fig"
        figi = fullfile(Figures(i).folder,Figures(i).name);
        openfig(figi, 'visible');
    end
end
end