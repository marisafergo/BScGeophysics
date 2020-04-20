function [v_p, v_s, v_phi ] = velocities_f(k,g,rho)
% +-----------------------------------------------------------+
% |function [v_p v_s v_phi ] = velocitiesf(k,g,rho)           |
% | Matlab function to calculate seismic velocities from the  |
% | bulk modulus, shear modulus and density.                  |
% | 11/03/2017 - Marisabel Gonzalez                           |
% +-----------------------------------------------------------+

% +-----------------------------------------------------------+
% | k - bulk modulus                                          |
% | g - shear modulus                                         |
% | rho - density                                             |
% | v_s - shear wave velocity                                 |
% | v_p - compressional wave velocity                         |
% | v_phi - bulk sound velocity                               |
% +-----------------------------------------------------------+

% +-----------------------------------------------------------+
% calculate compressional wave velocity in kms^-1
% +-----------------------------------------------------------+

v_p = sqrt(((k*10^9)+((4/3)*(g*10^9)))/rho)/10^3;

% +-----------------------------------------------------------+
% calculate shear wave velocity in kms^-1
% +-----------------------------------------------------------+

v_s = sqrt((g*10^9)/rho)/10^3;

% +-----------------------------------------------------------+
% calculate bulk sound velocity in kms^-1
% +-----------------------------------------------------------+

v_phi = sqrt((k*10^9)/rho)/10^3;

% +-----------------------------------------------------------+
% Note that:
% GPa = 10^9 Pa 
%        = 10^9 Nm-3 
%        = 10^9 kg ms-2 m -3
%        = 10^9 kg m-2s-2
% +-----------------------------------------------------------+
