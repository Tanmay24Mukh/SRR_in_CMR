function F=deformation_Gradient(Ux,Uy,Uz)
%This function calculates the deformation gradient matrix from the Displacement
%vectors
%  F = deformation_Grad(Ux,Uy)   or (3D)  F = deformation_Grad(Ux,Uy, Uz)
%
% inputs,
%   Ux,Uy: The displacement vector in
%           x and y direction (same as registration variables Tx, Ty)
%   Uz: The displacement vector in z direction.
%
% outputs,
%   E the 3-D deformation gradient tensor defined by Lai et al. 1993
%      

%%
if(~exist('Uz','var')) % Detect if 2D or 3D inputs
    % Initialize output matrix
    F=zeros([size(Ux) 2 2]);
    % displacement images gradients
    [Uxy,Uxx] = gradient(Ux);
    [Uyy,Uyx] = gradient(Uy);
    % Loop through all pixel locations
    for i=1:size(Ux,1)
        for j=1:size(Ux,2)
            % The displacement gradient
            Ugrad=[Uxx(i,j) Uxy(i,j); Uyx(i,j) Uyy(i,j)];
            F(i,j,:,:)=eye(2)+Ugrad;
        end
    end
else
    % Initialize output matrix
    F=zeros([size(Ux) 3 3]);
    % displacement images gradients
    [Uxx,Uxy,Uxz] = gradient(Ux);
    [Uyx,Uyy,Uyz] = gradient(Uy);
    [Uzy,Uzx,Uzz] = gradient(Uz);
    % Loop through all pixel locations
    for i=1:size(Ux,1)
        for j=1:size(Ux,2)
            for k=1:size(Ux,3)
                % The displacement gradient
                Ugrad=[Uxx(i,j,k) Uxy(i,j,k) Uxz(i,j,k); Uyx(i,j,k) Uyy(i,j,k) Uyz(i,j,k);Uzx(i,j,k) Uzy(i,j,k) Uzz(i,j,k)];
                % The deformation gradient
                F(i,j,k,:,:,:)=eye(3)+Ugrad;
            end
        end
    end
end