% %% 3D slices
fig = get(gcf,'Children');
a = get(fig(2),'Children');
% for i = 1:size(a,1)
% for i = [2:2:8,12:14]
% for i = [1:2:8]
% for i = [12]
for i = [3:8]
    a1 = a(i);
    f = 1; l = 0;
    X = a1.XData(f:end-l,f:end-l);
    Y = a1.YData(f:end-l,f:end-l);
    Z = a1.ZData(f:end-l,f:end-l);
    C = a1.CData(f:end-l,f:end-l);
    figure(7);
    hold on
    if i ~= 20
        t = surf(X,Y,Z,C,'FaceColor','texturemap','EdgeColor','none');
%         min(a(1).CData(:))
%         max(a(1).CData(:))
        colormap('gray')
        t.AlphaDataMapping = 'none'; % interpet alpha values as transparency values
        t.FaceAlpha = 'texturemap'; % Indicate that the transparency can be different each pixel

        alpha(t,double(~isnan(t.CData))*0.8)

    else
        t = surf(a1.XData/2,a1.YData,a1.ZData/2,'FaceColor','magenta','EdgeColor','none');
        t.FaceAlpha = 0.6;
    end
%     t.clim(t,[min(a(1).CData(:)),max(a(1).CData(:))])
    axis off

end
%% 2D res calc
% a = get(gcf,'Children');
% b = get(a,'Children');
% I1 = b{1}.CData;I2 = b{2}.CData;
% ratio = [0.5,0.5];
% I2_resample = img_process_resample(I2,ratio);
% I1_comp = (I1(2:end-1,2:end-1));
% function img_q=img_process_resample(img,ratio)
% 
% % returns a uint8
% F = griddedInterpolant(double(img));
% F.Method='cubic';
% if(size(img,3)>1)
%     
%     [sx,sy,sz] = size(img);
%     xq = (1:ratio(1):sx)';
%     yq = (1:ratio(2):sy)';
%     zq = (1:ratio(3):sz)';
%     img_q = F({xq,yq,zq});
%     %img_q = uint8(F({xq,yq,zq}));
% else
%     [sx,sy] = size(img);
%     xq = (1:ratio(1):sx)';
%     yq = (1:ratio(2):sy)';
%     img_q = F({xq,yq});
%     
% end
% end
%% 3D slices
% a = get(gcf,'Children');
% original = 'n';
% % a1 = a(1);
% % for i = 1:size(a,1)
% for i = [1]
%     %     for i = [1:8]
%     if original == 'y'
%         a1 = a(2).Children(i);
%     else
%         a1 = a(1).Children(i);
%     end
%     figure(7);
%     hold on
%     t = surf(a1.XData,a1.YData,a1.ZData,a1.CData,'FaceColor','texturemap','EdgeColor','none');
%     colormap('hot')
%     t.AlphaDataMapping = 'none'; % interpet alpha values as transparency values
%     t.FaceAlpha = 'texturemap'; % Indicate that the transparency can be different each pixel
%     if original == 'y'
%         alpha(t,double(~isnan(a1.CData))*0.8)
%     else
%         alpha(t,double(ones(size(a1.CData)))*0.8)
%     end
%     
%     
%     
%     
%     
%     %     clim(t,[min(a(1).CData(:)),max(a(1).CData(:))])
%     axis off
%     
% end
%% 3D slices
% a = get(gcf,'Children');
% original = 'n';
% a1 = get(a,'Children');
% test = a1(2);
% patch1 = test{1}(1);patch2 = test{1}(2);
% 
% f = patch2.Faces;v = patch2.Vertices;
% c = patch2.FaceVertexCData;
% 
% % SA Only
% slice = v(:,3)== -30 | v(:,3)== -50 | v(:,3)== -70;
% 
% % SA and endo
% slice = v(:,3) < 0;
% 
% flv = patch1.Faces; vlv = patch1.Vertices;
% clv = patch1.FaceVertexCData;
% 
% 
% slice_index = find(slice ~= 0);
% vslice = v.*slice;
% cslice = c.*slice;
% fslice = f((sum(ismember(f,slice_index),2)>2),:);
% 
% % figure(11);
% % patch('Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','interp')
% figure(11);
% patch('Faces',fslice,'Vertices',vslice,'FaceVertexCData',cslice,'FaceColor','interp', 'EdgeAlpha',0.4)
% hold on
% patch('Faces', flv, 'Vertices', vlv, 'FaceVertexCData', clv, 'FaceAlpha',0.05,'EdgeAlpha',0)
% % map = [0 0 0.5
% %     0 0.5 1
% %     1 1 1
% %     1 0 0
% %     0.5 0 0];
% colormap(customcolormap_preset('red-white-blue'))
% colorbar
% axis off
%% 3D No slices
% a = get(gcf,'Children');
% % original = 'n';
% a1 = get(a,'Children');
% test = a1(4);
% patch1 = test{1};
% f = patch1.Faces;v = patch1.Vertices;
% c = patch1.FaceVertexCData;
% 
% % Uncomment if ED figure
% % patchED = test{1};
% % fED = patchED.Faces;vED = patchED.Vertices;
% % cED = patchED.FaceVertexCData;
% 
% % figure(11);
% % patch('Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','interp','LineStyle','none')
% 
% figure(12);
% patch('Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','interp')
% % hold on
% % patch('Faces',fED,'Vertices',vED,'FaceVertexCData',cED,'FaceColor','interp','FaceAlpha',0.05)
% 
% colormap(customcolormap_preset('red-white-blue'))
% axis off