function E_rate=strain_rate(timestep,Ux,Uy,Uz)
%%
% Goal: Calculate the strain rate from displacement fields
%
%%
%======> This is a work in progress.
%
%======> :
%
% INPUTS:
%           E, matrix - Strain values: 4D/5D matrix of format E(x,y,:,:) E(x,y,z,:,:,:)
%           timestep, float - timestep size in seconds
% OUTPUTS:
%           E_rate, matrix - Strain rates: same size as E. Calculated from
%           symmetric part of E.
%
%
%
%
%======
% Developed by MK on 2021_06_29
% Last rev by MK on 2021_12_04
%
%======> This is a work in progress.
%%


if(~exist('Uz','var')) % Detect if 2D or 3D inputs
    % Initialize output matrix
    E_rate=zeros([size(Ux) 2 2]);
    % velocity gradients
    [Vxy,Vxx] = gradient(Ux./timestep);
    [Vyy,Vyx] = gradient(Uy./timestep);
    % Loop through all pixel locations
    for i=1:size(Ux,1)
        for j=1:size(Ux,2)
            % The velocity gradient
            Vgrad=[Vxx(i,j) Vxy(i,j); Vyx(i,j) Vyy(i,j)];
            L=Vgrad';
            
            E_rate(i,j,:,:)=1/2*(L+L'); %symmetric part
            %W_rot(i,j,:,:)=1/2*(L-L');  %skew symmetric part
        end
    end
else
    % Initialize output matrix
    E_rate=zeros([size(Ux) 3 3]);
    % velocity gradients
    [Vxx,Vxy,Vxz] = gradient(Ux./timestep);
    [Vyx,Vyy,Vyz] = gradient(Uy./timestep);
    [Vzy,Vzx,Vzz] = gradient(Uz./timestep);
    % Loop through all locations
    for i=1:size(Ux,1)
        for j=1:size(Ux,2)
            for k=1:size(Ux,3)
                % The displacement gradient
                Vgrad=[Vxx(i,j,k) Vxy(i,j,k) Vxz(i,j,k); Vyx(i,j,k) Vyy(i,j,k) Vyz(i,j,k);Vzx(i,j,k) Vzy(i,j,k) Vzz(i,j,k)];
                L=Vgrad';
                
                E_rate(i,j,k,:,:)=1/2*(L+L'); %symmetric part
                %W_rot(i,j,k,:,:)=1/2*(L-L');  %skew symmetric part
            end
        end
    end
end

end