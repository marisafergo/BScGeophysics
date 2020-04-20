% PRACTICAL 4
% Function

% THIS FUNCTION PERFORMS WEIGHTED, LINEAR LEAST-SQUARES FITTING OF 
% ANY SET OF x, y AND sigmay VALUES


% ______________________________________________________________
%|                   Marisabel and Abdullah                     |
%|                       16/10/2017                             |
%|______________________________________________________________|


% ______________________________________________________________
%|                         NOMENCLATURE                          
%|______________________________________________________________

% A: y-intercept
% B: gradient
% sigA: associated error in A
% sigB: associated error in B
% wi: weights
% delta: math operator implying difference or change



function [A,sigA,B,sigB] = p4_function(x,y,sigy)


wi = 1./(sigy.^2);         %identifying wi
smwi = sum(1./(sigy.^2));  %sum of wi
smwix2 = sum(wi.*(x.^2));  %sum of wi times x^2
smwiy = sum(wi.*y);        %sum of wi times y
smwix = sum(wi.*x);        %sum of wi times x
smwixy = sum(wi.*x.*y);    %sum of wi times x times y
delta = (smwi.*smwix2) - (smwix.*smwix); %calculating delta


    A = ((smwix2.*smwiy) - (smwix.*smwixy))./delta;
    B = ((smwi.*smwixy) - (smwix.*smwiy))./delta;
    sigA = sqrt(smwix2./delta);
    sigB = sqrt(smwi./delta);
    
end

% ______________________________________________________________
%|                              END                    
%|______________________________________________________________
