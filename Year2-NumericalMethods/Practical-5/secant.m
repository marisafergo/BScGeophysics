% PRACTICAL 5
% (if possible please correct the wrong commands so we know how it should
% have been done)

% ______________________________________________________________
%|                   Abdullah and Marisabel                     |
%|                       23/10/2017                             |
%|______________________________________________________________|

function [ ] = secant(f,xi,elim,maxit)

% This MATLAB function finds the root of a predefined function (given
% at the command line), from one initial guess, by using the Secant
% method (using perturbation).

% No output in the MATLAB function as the results will be writen to a file
% called root_it.dat for each iteration and plotted upon completion 


% ______________________________________________________________
%|                        Relevant nomenclature                        
%|______________________________________________________________

% xi: initial guess
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

%     To compute the next root approximation is used:
%     x_i+1 = xi - (f(xi)dx/f(xi+dx)-f(xi))        (1)

%      To compute the approximate error is used:
%      ea = |(x_i+1 - xi)/x_i+1)| * 100%           (2)



% Given values
dx = 0.001; % perturbation of dx

% Initial guess
xi(1)= xi;



% Writing headers  
 fid = fopen('root_it.dat','w');  % creating file root_it.dat for writing
 fprintf(fid,'%23s %23s %23s\n','Iteration Number', 'Root Estimate', ...
     'Error at iteration');
 
 
 
 
 for i = 1:1:maxit
      
 xi(i+1) = xi(i) - ((f(xi(i))*dx)/(f(xi(i)+dx)-f(xi(i)))); % equation (1)
 
 
 
 
   if ( xi(i+1)~= 0 )     % if the estimated root is different to zero,
                          % compute ea normally by using equation (2)
                         
    ea(i+1) = abs( ((xi(i+1)) - (xi(i)))/(xi(i+1)))*100 ;    % equation (2)
    
   end 
       
    
  
   
    if ( f(xi(i+1))==0 )   % if the estimated root equals zero,
                           % set ea to zero and stop the script
       ea = 0;
       disp(' '); %blank line
       disp('Division by zero!');  % Error message displayed on screen for
                                   % division by zero
      break  
      
    end
   

 
    
    if (ea(i+1) < elim)   % if the approximate error ea is less than 
                        % the error limit defined in the MATLAB function,
                        % stop the script
      break 
    end
    
    
    xi(i)=xi(i+1);

   
 
       
 fprintf(fid,'%20i %20.4f %20.4f\n',i,xi(i),ea(i+1)); % storing result in
                                                    % root_it.dat
    
 end
 

 
%  %Plotting the estimated root against the iteration number
%  v_i = [1:i];             % vector containing the iterations
%   v_xi = xi(i)   % vector containing the roots
% 
%  plot(xi(i),v_i, 'g-');

 
% Adding title and axis labels
title('Plot of the estimated root against the iteration number')
xlabel('Iteration')                    
ylabel('Root')  

fclose(fid); % closing file root_it.dat
 
end






% ______________________________________________________________
%|                              END                    
%|______________________________________________________________

