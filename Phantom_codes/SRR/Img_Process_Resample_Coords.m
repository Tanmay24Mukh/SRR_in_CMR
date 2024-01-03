function [X_r, Y_r, Z_r] = Img_Process_Resample_Coords(X, Y, Z, ratio, expand)
%%
%======> This is a work in progress.
%
%======> :
%
%       INPUTS:
%               X, Y, Z: of form X{kk,tt}(ii,jj)
%               ratio: of rom [1 1 1]
%               expand : [0 0; 0 0; 0 0]
%       OUTPUTS:
%       		[X_q, Y_q, Z_q]
%
%
%
%
%======
% Developed by MK on 2021_11_11
% Last rev by MK on 2021_12_06
%
%======> This is a work in progress.
%%
X = cat(3,X{:,1});
Y = cat(3,Y{:,1});
Z = cat(3,Z{:,1});

method{1} = 'linear';


X_r = Img_Process_Resample(X, ratio,expand, method);
Y_r = Img_Process_Resample(Y, ratio,expand, method);
Z_r = Img_Process_Resample(Z, ratio,expand, method);


end