function E=strain_Lagrangian_defGradient(F)
% Calculate the Eulerian strain from displacement images
%
%  E = STRAIN(F)
%
% inputs,
%   Ux,Uy: The displacement vector images in
%           x and y direction (same as registration variables Tx, Ty)
%   Uz: The displacement vector image in z direction.
%
% outputs,
%   E the 3-D lagrangian strain tensor images defined by Lai et al. 1993
%      with dimensions [SizeX SizeY 2 2] or in 3D [SizeX SizeY SizeZ 3 3]
% Initialize output matrix
E=zeros(size(F));
if(size(F,2)==4) % Detect if 2D or 3D inputs
    
    for ii=1:size(F,1)
        for jj=1:size(F,2)
            % the 3-D Eulerian strain tensor
            E(ii,jj,:,:)=1/2*(squeeze(F(ii,jj,:,:))'*squeeze(F(ii,jj,:,:))-eye(2));
        end
    end
else
    for ii=1:size(F,1)
        for jj=1:size(F,2)
            for kk=1:size(F,3)
                E(ii,jj,kk,:,:)=1/2*(squeeze(F(ii,jj,kk,:,:))'*squeeze(F(ii,jj,kk,:,:))-eye(3));

            end
        end
    end
end