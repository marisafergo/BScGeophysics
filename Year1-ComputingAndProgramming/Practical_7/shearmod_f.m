function [g] = shearmod_f(e_c)
% +-----------------------------------------------------------+
% |function [g] = shearmod_f(e_c)                             |
% | Matlab script to calculate the shear modulus of           |
% | an orthorhombic crystal from its nine elastic constants   |
% | 11/03/17 - Marisabel Gonzalez                             |
% +-----------------------------------------------------------+

% +-----------------------------------------------------------+
% | g - shear modulus                                         |
% | e_c - column vector containing the elastic constants      |
% +-----------------------------------------------------------+

g = (1/15)*(e_c(1)+e_c(2)+e_c(3) ...
  -  (e_c(4)+e_c(5)+e_c(6)) ...
  + 3*(e_c(7)+e_c(8)+e_c(9)));

