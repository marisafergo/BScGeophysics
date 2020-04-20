function [ I ] = richardson( f,ll,ul,ni1,ni2 )
%UNTITLED2 Summary of this function goes here
% ______________________________________________________________
%|                   Marisabel Gonzalez                         |
%|                       //2017                             |
%|______________________________________________________________|

% ______________________________________________________________
%|                         Relevant Nomenclature                       
%|______________________________________________________________

% I: improved estimate of integral
% I1: estimate of the integral calculated using an interval width h1
% I2: estimate of the integral calculated using an interval width h2
% ll: lower integration limit
% ul: upper integration limit
% ni1: interval 1
% ni2: interval 2
% h1:
% h1: 


% n-1 is used to find the number of intervals


% f=@(x) (1/sqrt(2*pi))*exp(-(x^2)/2)
% richardson(f,-1,1,10,20)


% Calling the functions 

[ I1,h1 ] = ctrap( f,ll,ul,ni1 );
[ I2,h2 ] = ctrap( f,ll,ul,ni2 );

I = I2 + ( I1 - I2 )/( 1 - (h1/h2)^2 );


end



