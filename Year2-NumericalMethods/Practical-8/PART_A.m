% This MATLAB script takes any set of experimental data and uses linear 
% interpolation to estimate the value of f(x) at any x value that lies 
% within the range studied

% ______________________________________________________________
%|                   Abdullah and Marisabel                     |
%|                       20/11/2017                             |
%|______________________________________________________________|


%Clearing the workspace, figures and the command window
clear all
clc
% clf


% ______________________________________________________________
%|                        Relevant nomenclature                     
%|______________________________________________________________

% file: variable storing the file containing the data provided by user
% x: x values stored in the file
% fx: y values stored in the file
% x_fx: x value used for interpolation provided by user
% x_l: lower limit of x
% x_u: upper limit of x
% fx_l: lower limit of fx_l
% fx_u: upper limit of fx_u
% fx_i: interpolated value of f(x) at x_fx


% ______________________________________________________________
%|                        Relevant equations                       
%|______________________________________________________________

% Linear Interpolation:
% fx_i = fx_l + (((fx_u - fx_l) / (x_u - x_l)) * (x_fx - x_l))       (1)




% Displaying on screen the purpose of the script
disp('This MATLAB script takes any set of experimental data and uses linear')
disp(' interpolation to estimate the value of f(x) at any x value that lies')
disp(' within the range studied')

disp(' ')   % blank line


% Asking user for the filename containing the experimental data
filename = input('Please enter the filename containing the experimental data: ', 's');
file = load(filename);

disp(' ') % blank line

x = file(:,1);
fx = file(:,2);


% Asking user for the x value at which f(x) is desired
x_fx = input('Please enter the x value at which f(x) is desired: ', 's');



x_min = min(x);              % minimum values of x on the file

x_max = max(x);              % maximum values of x on the file




 while (x_fx < x_min) | (x_fx > x_max)  % checking if the provided x value x_fx
                                        % lies within the range of x
                                     
disp(['The x value provided x_fx does not lie within the range of x. ' ...
    'Please provide a different x value x_fx.'])

disp(' ') % blank line

x_fx = input('Please enter the x value at which f(x) is desired: ', 's');
      
 end



for i = 1:length(x)
    
  if x_fx == x(i)                    % checking if the provided x value x_fx
                                     % is equivalent to one of the values
                                     % of the file presented by the user
  
                                     
  disp ('x_fx is within the values of the file.')
  
  x = x(i);
  fx = fx(i);
  
  disp([' The value of x is' num2str(x) 'and the value of fx is' num2str(fx) '. '])
  
  disp(' ') %blank line
  
  break
  end 

end

% If the inputted x value x_fx does not match the any of the listed values
% in the file provided, the following command is run to find the bracketing
% values of x


for j = 1:length(x)
  

    if (x_fx > x(j)) & (x_fx < x(j+1))
 

        x_l = x(j);
        x_u = x(j+1);

        fx_l = fx(j);
        fx_u = fx(j+1);


   
    end 
end


% This command performs a linear interpolation using equation (1)

fx_i = fx_l + (((fx_u - fx_l) / (x_u - x_l)) * (x_fx - x_l));


disp(['The estimated  value of f(x) at the provided x value x_fx is: ' ...
    num2str(fx_i) '.' ])

disp(' ') % blank line

% ______________________________________________________________
%|                              END                    
%|______________________________________________________________
