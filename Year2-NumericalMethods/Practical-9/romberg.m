function [ I ] = romberg( f,ll,ul,ni,nl )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


% f=@(x) (1/sqrt(2*pi))*exp(-(x^2)/2)
% romberg(f,-1,1,8,4)


% ______________________________________________________________
%|                         Relevant Nomenclature                       
%|______________________________________________________________

% ni: the minimum number of intervals to use for the composite trapezoidal 
%     rule

% nl: the number of integration levels to use




% Calling the function in PART A to calculate the initial estimate 
% of the integral

[ I,h ] = ctrap( f,ll,ul,ni1 );

for k =                         
    
    for j = 
        
    end
    
end     

end

