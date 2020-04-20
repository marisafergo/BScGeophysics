
    

% +-----------------------------------------------------------+
% | Matlab script to calculate an approximation to sinx       |
% | from a Taylor expansion:                                  |
% |                                                           |
% |              x^3   x^5   x^7   x^9                        | 
% | sin(x) = x - --- + --- - --- + --- -  ....                |
% |               3!    5!    7!    9!                        |
% |                                                           |
% | x must lie between -2*pi and +2*pi                        |
% |                                                           |   
% | 08.02.2014 - Stephen Stackhouse                           |
% +-----------------------------------------------------------+

% +-----------------------------------------------------------+
% | i     - loop counter                                      |
% | x     - value supplied by user                            |   
% | n     - the factorial of i                                |   
% | nmax  - maximum number of iterations
% | sinx  - stores estimated value of sin(x)                  |
% | term  - stores current term in Taylor expansion           | 
% | sign  - stores sign for current term in Taylor expansion  |
% +-----------------------------------------------------------+




% tell the user what the program does 
disp('This program estimates sin(x) (x is in radians)')


% ask user for value of x and read it in 
x = input('Please enter a value of between -2*pi and +2*pi: ');



% check that x lies within the required range
if ((x < -2*pi) || (x > +2*pi))
    disp('x must be between -2*pi and +2*pi')
    return
end



% initialize values for loop

sinx = 0;   % initialize sinx
sign = 1;   % initialize sign
nmax = 100; % initialize nmax




% repeat loop while term < = 0.00001 

for i=1:2:nmax % use only odd values
    term = ((x^i)/fact(i));

% if magnitude of a term fall below required accuracy break
    if (term <= 0.00001)
        disp('reached the required accuracy')
        break
    end

% calculate sum
    sinx = sinx + sign*term;
% change sign
    sign = -sign;
end



% write out the results 
fprintf('%s %12.8f\n','x-approx =',sinx);
fprintf('%s %12.8f\n','x-matlab = ',sin(x))


% ______________________________________________________________
%|                              END                  
%|______________________________________________________________

