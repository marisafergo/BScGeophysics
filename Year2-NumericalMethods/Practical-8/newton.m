 function [fxint] = newtonint(x,fx,xint)
% +-----------------------------------------------------------+
% | function [fxint] = newtonint(x,fx,xint)                   |
% | MATLAB function fits a Newton interpolating polynomial to | 
% | a set of supplied x and f(x) values, to predict the value |
% | of f(x) at xint.                                          | 
% |                                                           |
% | 15/11/2014 - Stephen Stackhouse                           |
% +-----------------------------------------------------------+

% +-----------------------------------------------------------+
% |     x - vector containing x values                        |
% |    fx - vector containing fx values                       |
% |  xint - x value at which to interpolate                   |
% | fxint - interolated value of f(xint)                      |
% |    dd - matrix storing the divided difference table       |
% |  mult - variable used to store (x-x1)*(x-x2) ...          |
% +-----------------------------------------------------------+

% +-----------------------------------------------------------+
% initialize divided difference table 
% +-----------------------------------------------------------+

dd = zeros(length(x),length(x));
dd(:,1) = fx(:); 

% +-----------------------------------------------------------+
% calculate divided difference table 
% +-----------------------------------------------------------+

for j=2:length(x)
  for i=1:length(x)-j+1
     dd(i,j) = (dd(  ,  )-dd(  , ))/(x(  ,1)-x(  ,1));
  end
end 

% +-----------------------------------------------------------+
% calculate fxint from xint 
% +-----------------------------------------------------------+

mult = 1; % initialize mult used to calculate (x-x1)*(x-x2)..
fxint = dd(1); % used to store fxint
for i = 2:length(x)
  mult = mult*(xint-x(  ,1));
  fxint = fxint + dd(1,i)*mult;
end

% +-----------------------------------------------------------+
