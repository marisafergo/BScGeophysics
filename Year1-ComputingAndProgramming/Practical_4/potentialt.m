% Matlab script to calculate the Potential Temperature (tetha)
% 17/02/2017 - Marisabel Gonzalez

%+-----------------------------------------------------+
%| T = absolute temperature [K]                        |
%| p = pressure [Pa]                                   |
%| ps = constant value (1000hPa), where 1hPa=100Pa     |
%| power = contant power (-0.288)                      |
%|                                                     |
%|  The Potential temperature result is in K (Kelvin)  |
%+-----------------------------------------------------+


disp(['SCRIPT TO EVALUATE THE POTENTIAL TEMPERATURE AT A GIVEN PRESSURE'...
'AND TEMPERATURE'])
disp (' ')  %blank space



% TEMPERATURE AND PRESSURE VALUES PROVIDED BY USER
T = input(['Please enter the value of the absolute' ...
' temperature (in K): ']);
p = input('Please enter the value of the pressure (in Pa): ');
disp (' ') %blank space



% CONSTANT VALUES 
ps = 100000;
power = -0.288;



% EXPRESSION TO EVALUATE THE POTENTIAL TEMPERATURE
tetha = T * ((p/ps)^(power));
disp(['The potential temperature at ' num2str(T) ' K and ' ...
    num2str(p) ' Pa is'])
disp(tetha)




% Não esquecer os ([]) quando misturando commands!!! 