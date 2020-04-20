% ______________________________________________________________
%|                   Marisabel Gonzalez                         |
%|                       03/03/2017                             |
%|______________________________________________________________|


function [theta] = potentialt_function(T,p)
% +-----------------------------------------------------------+
% | function [theta] = potentialt_function(t,p)               |
% | Matlab FUNCTION to calculate potential temperature from   |
% | the temperature and pressure supplied by the user.        |
% |                                                           |
% |                                                           |
% | The potential temperature is expressed as                 |
% |                                                           |
% |               p                                           |
% | theta = t * (-----)^(-0.288)                              |
% |              p_s                                          |
% |                                                           |
% | where                                                     |
% | t = temperature                                           |
% | p = pressure                                              |
% | p_s = reference pressure (equal to 100 000 Pa)            |
% | theta = potential temperature                             |
% +-----------------------------------------------------------+



% REFERENCE PRESSURE
p_s = 100000; % Pa (Pascals)



%EXPRESSION TO CALCULATE THE POTENTIAL TEMPERATURE
theta = T*(p/p_s)^(-0.288); 

end