function [n] = fact(i)
% +-----------------------------------------------------------+
% | function [n] = fact(i)                                    |
% | Matlab function to calculate the factorial of a number i  |
% | which is returned as n.                                   | 
% | 08.02.2014 - Stephen Stackhouse                           |
% +-----------------------------------------------------------+

n = 1;

for j =1:1:i
    n=n*j;
end

% +-----------------------------------------------------------+
