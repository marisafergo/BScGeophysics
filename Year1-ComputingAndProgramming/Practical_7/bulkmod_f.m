function [k] = bulkmod_f(e_c)
% +-----------------------------------------------------------+
% | function [k] = bulkmod_f(cij)                             |
% | Matlab function to calculate the bulk modulus of          |
% | an orthorhombic crystal from its nine elastic constants   |
% | 11/03/17          Marisabel Gonzalez                      |
% +-----------------------------------------------------------+

% +-----------------------------------------------------------+
% | k - bulk modulus                                          |
% | e_c - column vector containing the elastic constants      |
% +-----------------------------------------------------------+

k = (1/9)*(e_c(1)+e_c(2)+e_c(3) ...
  + 2*(e_c(4)+e_c(5)+e_c(6)));

% +-----------------------------------------------------------+