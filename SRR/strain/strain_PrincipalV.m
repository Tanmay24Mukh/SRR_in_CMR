function AA=strain_PrincipalV(E)
%%
%E:     The strain matrix: [Exx Exy Exz;Eyx Eyy Eyz;Ezx Ezy Ezz]
%E_pr:  Principal Strains
%D:     Prinipal Directions
%%
%======> This is a work in progress.
%
%======> :
%
%           INPUTS:
%
%
%
%           OUTPUTS:
%
%
%
%
%======
% Developed by MK on 2020_12_13
% Last rev by MK on 2021_12_04
%
%======> This is a work in progress.
%%
[D,E_pr]=eig(E);
E_pr=diag(E_pr);
[E_pr,I]=sort(E_pr,'descend');
D=D(:,I);
AA=D.*repmat(E_pr,1,3)';
end