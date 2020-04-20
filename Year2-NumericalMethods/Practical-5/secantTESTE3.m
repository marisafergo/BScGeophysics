% PRACTICAL 5
% ______________________________________________________________
%|                   Abdullah and Marisabel                     |
%|                       xx/xx/2017                             |
%|______________________________________________________________|

%Clearing the workspace, figures and the command window
clear all
clf
clc


function [ ] = secante(f,x,elim,maxit)

% This MATLAB function finds the root of a predefined function (given
% at the command line), from one initial guess, by using the Secant
% method (using perturbation).



% ______________________________________________________________
%|                        Relevant nomenclature                        
%|______________________________________________________________

% x: initial guess
% x_n: the new estimate of the root
% ea: approximate error at iteration i+1
% dx: perturbation of delta_x, constant value = 0.001
                                % let delta_x = dx for convenience
% f: function defined at the command line
% elim: the error limit, constant value = 0.000001%
% maxit: maximum number of iterations, contant value = 40




% ______________________________________________________________
%|                        Relevant equations                       
%|______________________________________________________________

% Initial guess:  x_i+1 = xi - (f(xi)dx/f(xi+dx)-f(xi))        (1)

% Approximate error: ea = |(x_i+1 - xi)/x_i+1)| * 100%         (2)





% Asking user to define the function 
% function [ ] = evaluate(f,x)
% fx = f(x);
% disp([?f(x) = ?, num2str(fx)]);
% end


% f_defined = input('Please enter a function: ' ,'s');
% f = inline(f_defined);


% Given values
dx = 0.001; % perturbation of dx
elim = 0.000001; % error limit
maxit = 40; % max number of iterations
x(1) = -1; %intial guess

% No output in the MATLAB function as the results will be writen to screen
% for each iteration and plotted upon completion 

iteration = 0;


 for i= 1:1:maxit
     
     x(i) = x(i) - ((f(x(i))*dx)/(f(x(i)+dx)-f(x(i))));  % equation (1)
         
     iteration = iteration + 1;
     
     ea = abs((x(i+1)-x(i))/x(i+1))*100;      % equation (2)

     if (ea < elim)
         root = x(i);
         iteration = iteration;
         
         break 
     end
 end

end

% disp([' The iteration number is: ' num2str(iteration) ]);
% disp([' The estimated value for the root is: ' num2str(root) ]);
% disp([' The error at each iteration is: ' num2str(ea) ]);

 






% ______________________________________________________________
%|                              END                    
%|______________________________________________________________

