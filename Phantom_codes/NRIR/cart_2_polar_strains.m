function [results] = cart_2_polar_strains(results)
% 
% results_fid = results.filepath;

k_start=1;
k_end=size(results.img.resampled{1},3);

Ep=cell(size(results.E_l_masked));
Ep_masked=cell(size(results.E_l_masked));

for(tt=1:size(results.E_l_masked,2))
    
    if ~isempty(results.E_l_masked{tt})
        
        Ep{tt}=nan(size(results.E_l_masked{tt}));
        
        Ep_masked{tt}=nan(size(results.E_l_masked{tt}));
        
        for kk=k_start:1:k_end
            
            strain=results.E_l_masked{tt}(:,:,kk,:,:);
            mask=results.img.masked{tt}(:,:,kk);
            [row,col]=find(mask==1);
            center=[mean(row),mean(col)];
            
            if(~isempty(row))
                for ii=1:size(row,1)
                    [theta, rho]=cart2pol(col(ii)-center(2),row(ii)-center(1));
                    Ep_masked{tt}(row(ii),col(ii),kk,:,:)=transfer(squeeze(strain(row(ii),col(ii),1,:,:)),theta);
                end
                
                %This one includes all the data (not just the masked areas)
                for ii=1:size(Ep{tt},1)
                    for jj=1:size(Ep{tt},2)
                        [theta, rho]=cart2pol(jj-center(2),ii-center(1));
                        Ep{tt}(ii,jj,kk,:,:)=transfer(squeeze(results.E_l{tt}(ii,jj,kk,:,:)),theta);
                    end
                end
            end
        end
    else
        Ep{tt}=[];
        Ep_masked{tt}=nan(size(results.E_l_masked{tt}));
    end
end
results.E_l_polar=Ep;
results.E_l_polar_masked=Ep_masked;
% save(results.filepath,'results', '-v7.3');
end

function e_p=transfer(e,theta)
Q=[...
    cos(theta), -sin(theta), 0;...
    sin(theta), cos(theta), 0;...
    0, 0, 1];
e_p=Q*e*Q';
end