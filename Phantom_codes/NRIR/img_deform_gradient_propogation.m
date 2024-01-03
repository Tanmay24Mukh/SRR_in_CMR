function F_tot = img_deform_gradient_propogation(Ux,Uy,Uz)
% Calculate the Eulerian strain from displacement images
%
%  E = STRAIN(Ux,Uy)   or (3D)  E = STRAIN(Ux,Uy, Uz)
%
% inputs,
%   Ux,Uy: The displacement vector images in
%           x and y direction (same as registration variables Tx, Ty)
%   Uz: The displacement vector image in z direction.
%
% outputs,
%   E the 3-D lagrangian strain tensor images defined by Lai et al. 1993
%      with dimensions [SizeX SizeY 2 2] or in 3D [SizeX SizeY SizeZ 3 3]
%
% Source used:
%   Khaled Z et al. "Direct Three-Dimensional Myocardial Strain Tensor 
%   Quantification and Tracking using zHARP"
%
% Function is written by D.Kroon University of Twente (February 2009)

if(~exist('Uz','var')) % Detect if 2D or 3D inputs
    % Initialize output matrix
    E=zeros([size(Ux) 2 2]);
    % displacement images gradients
    [Uxy,Uxx] = gradient(Ux);
    [Uyy,Uyx] = gradient(Uy);
    % Loop through all pixel locations
    for i=1:size(Ux,1)
        for j=1:size(Ux,2)
            % The displacement gradient
            Ugrad=[Uxx(i,j) Uxy(i,j); Uyx(i,j) Uyy(i,j)];
            F=eye(2)+Ugrad;
            F_tot(i,j,:,:)=F;
        end
    end
else
    % Initialize output matrix
    E=zeros([size(Ux) 3 3]);
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
%                 F=inv(eye(3)-Ugrad);
                F=eye(3)+Ugrad;
                F_tot(i,j,k,:,:)=F;
                % the 3-D Lagrangian strain tensor
            end
        end
    end
end