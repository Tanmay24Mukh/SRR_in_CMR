function [b weights] = inchull(testPt, pts)
% INCHULL returns if the point testPt is inside the convex hull of the set 
% of points pts. This is done by solving a linear program. The advantage is
% that it does not require to compute the convex hull and then can be used
% in high dimension. This is an alternative to inhull by John D'Errico that
% requires to compute the convex hull which is not always possible (try it 
% with points in dimension 50 for instance).
%
% The linear program relies on the fact that any point inside the convexe 
% hull of pts, denoted Pin, can be written as:
% Pin = sum(Wi Pi)
% where 0<=Wi, sum(Wi)=1 and Pi is a point in pts. The linear program is:
% minimise 1
% s.t.     Aeq x = beq
%          0 <= x
% where Aeq = [pts; 1 ... 1] and beq = [testPt; 1]. There is a solution x* 
% to this optimisation problem only if testPt is inside the convexe hull of
% the points on pts. The solution x* is then equal to weights.
%
% If testPt is inside the convex hull, the program also returns a weight 
% vector such as:
% testPt = pts * weights,           (1)
% where Wi>=0, sum(Wi) = 1. This is only to verify that the point really 
% belongs to the convex hull.
%
% Arguments (input):
% testPt - Point to test, a dx1 vector (column vector)
% pts    - List of points, a dxn matrix (n points of dimension d, [p1 ... pn])
%
% Arguments (output):
% b       - Boolean specifying if testPt is inside the convex hull of pts
% weights - Weight vectors
%
% Example usage:
% In 2 dimensions, 
% pts         = randn(2, 100)         ;   % 100 test points
% testPt      = [0 0]'                ; 
% [b weights] = inchull(testPt, pts)  ;
% should return b=1 and you can verify (1). In general, if you run 
% testPt == pts*weights
% it won't work but you can verify that norm(testPt-pts*weights) is very
% small.
%
% Author      : Hugo MERIC
% Homepage    : http://hugo.meric.perso.sfr.fr/index.html
% Release     : 1.0
% Release date: 2015-04-20
% --------------------
% ----- Initialization
% --------------------
% WARNING: I use the MOSEK interface (https://www.mosek.com/) to speed up 
% the simulations. This line can be deleted, the program will still work as 
% linprog is implemented in Matlab (MOSEK overwrites it). It is just going
% to be longer. If you also use MOSEK, adapt the path.
addpath '/home/hugo/mosek/7/toolbox/r2012a'
% Dimension of the test point
d = size(testPt, 1) ;
% Test if the dimensions are equal for the points in pts
if(size(pts,1)~=d)
    error('pts do not have the same dimension as testPt!') ;
end
% Number of points in pts
nbPts = size(pts, 2) ;
% ---------------------------------------------------
% ----- The linear program is expressed in Matlab as:
% ----- min f'x
% ----- s.t. Ax<b, 
%            Aeqx=beq,
%            and lb<x<ub
% ---------------------------------------------------
% Optimisation setup
f   = zeros(nbPts, 1) ; 
Aeq = [pts            ; ...
      ones(1, nbPts)] ;
beq = [testPt; 1]     ;
lb  = zeros(nbPts, 1) ;
% Run the optimisation
opts             = optimset('MaxIter', 10*nbPts)                  ;
[x, ~, exitflag] = linprog(f, [], [], Aeq, beq, lb, [], [], opts) ;
% Outputs
if(exitflag==1)
    b       = 1 ;
    weights = x ;
else
    b       = 0  ;
    weights = [] ;
end
end
