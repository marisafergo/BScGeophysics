% PRACTICAL 5

% f = @(x) ((4-x)*exp(-x/2))-2
% secant(f,1,0.000001,40)

% ______________________________________________________________
%|                   Abdullah and Marisabel                     |
%|                       23/10/2017                             |
%|______________________________________________________________|

%Clearing the workspace, figures and the command window
% clear all
% clf
% clc


function [ ] = secant(f,xi,elim,maxit)

% This MATLAB function finds the root of a predefined function (given
% at the command line), from one initial guess, by using the Secant
% method (using perturbation).

% No output in the MATLAB function as the results will be writen to screen
% for each iteration and plotted upon completion 


% ______________________________________________________________
%|                        Relevant nomenclature                        
%|______________________________________________________________

% xi: initial guess defined in the MATLAB function
% xi(i+1): the new estimate of the root
% ea: approximate error at iteration i+1
% dx: perturbation of delta_x, constant value = 0.001
                                % let delta_x = dx for convenience
% f: function defined at the command line
% elim: the error limit defined in the MATLAB function
% maxit: maximum number of iterations defined in the MATLAB function
% i: number of iterations

% ______________________________________________________________
%|                        Relevant equations                       
%|______________________________________________________________

% Initial guess:  x_i+1 = xi - (f(xi)dx/f(xi+dx)-f(xi))        (1)

% Approximate error: ea = |(x_i+1 - xi)/x_i+1)| * 100%         (2)



% Given values
xi(1) = xi; % initial guess
dx = 0.001; % perturbation of dx

           
 fid = fopen('root_it.dat','w');
 fprintf(fid,'%23s %23s %23s\n','Iteration Number', 'Root Estimate', ...
     'Error at iteration');
 
 for i = 1:1:maxit
                % maxit: maximum number of iterations, contant value = 40
     
     
 xi(i+1) = xi(i) - ((f(xi(i))*dx)/(f(xi(i)+dx)-f(xi(i))));  % equation (1)
           
  ea(i+1) = abs( ((xi(i+1)) - (xi(i)))/(xi(i+1)))*100 ;       % equation (2)
  
     if (ea(i+1) < elim)
       
         break 
     end 
    xi(i)=xi(i+1);
    
 fprintf(fid,'%20i %20.4f %20.4f\n',i,xi(i),ea(i+1));
    
 end
 
 fclose(fid); 

end




% ______________________________________________________________
%|                              END                    
%|______________________________________________________________

