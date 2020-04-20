% PRACTICAL 4
% Part 2

% This MATLAB script uses the best estimate of "a" obtained in p4_part1
% and plots Equation (1) and its associated error as confidence bands
% along with the thermal conductivity data.
% The values are read from the file "data".



% ______________________________________________________________
%|                   Marisabel and Abdullah                     |
%|                       16/10/2017                             |
%|______________________________________________________________|

% Clearing the workspace, figures and the command window
clear all
clf
clc

% ______________________________________________________________
%|                         NOMENCLATURE                          
%|______________________________________________________________

% k: thermal conductivity [in Wm^-1K^-1]
% ko: initial known value of k, where ko = 52.3 Wm^-1K^-1
% k_fit: best fit of k
% kmax: maximum uncertainty of k_fit
% kmin: minimum uncertainty of k_fit
% t: temperature [in Kelvin]
% to: initial known value of t, where to = 300 K
% a: unknown exponent
% sigk: standard deviation of k
% yf: equation for a linear function


% ______________________________________________________________
%|                        Relevant equations                       
%|______________________________________________________________


% Thermal conductivity of a mineral:
% k = k0(t0/t)^a                                            (1)

% Reformulation of equation (1) to obtain a linear relationship:
% ln(k) = ln(k0) + aln(to/t)                                (2)




% Displaying on screen the purpose of the script
disp('This MATLAB script uses the best estimate of "a" obtained in p4_part1')
disp('and plots Equation (1) and its associated error as confidence bands')
disp('along with the thermal conductivity data.')
disp('The values are read from the file "data".')


disp(' ') %blank line



% TASK 1: reading in values from file and loading them into individual
%column vectors
values = importdata('data');
t = values(:,1);      
k = values(:,2);
sigk = values(:,3);


% TASK 2: producing x,y and sigy

%given values
to = 300;
ko = 52.3;

% converting values to logarithms owing to simplify solving the equation
% for the unkwonw exponent "a"
x = log(to./t);
y = log(k);
sigy = sigk./k;


% TASK 3: creating and calling function p4_function
[A,sigA,B,sigB] = p4_function(x,y,sigy);


% TASK 4: finding a
yf = A + B.*x;   % best fit line (y=mx+c)
a = B;           % a is the gradient 

% TASK 5: computing the thermal conductivity k and its associated
% uncertainties
k_fit = ko.*((to./t).^a); % equation of the thermal conductivity of a mineral
kmax = ko.*((to./t).^(a+sigB));  %max value of k_fit
kmin = ko.*((to./t).^(a-sigB));  %min value of k_fit


% differentiating dk/da 
% remember that d/dx(a^x)=ln(a)*a^x
dk_da = (ko.*((to./t)).^a) .* (log(ko.*(to./t))); 

k_error = (abs(dk_da)).*sigB; % using the error propagation equation for a 
                              % function of one variable
                              % errorq = |dq/dx|*errorx

 
% TASK 7: plotting

hold on % this command allows multiple plotting



plot_1 = plot(t,k,'ko');                     % plotting the data
plot_2 = plot(t,k_fit,'m-');                 % plotting the function 
plot_3 = plot(t,kmax,'r-', t,kmin,'r-');     % along with its error bands


set(plot_2,'LineWidth',2);          % changing line width
errorbar(t,k,sigk,'ko');            % plotting error bars on the function



hold off % this commands stops multiple plotting

% Adding title and axis labels
title('Plot of thermal conductivity against temperature')
xlabel('Temperature [K]')                    
ylabel('Thermal Conductivity [W/mK]')  

% Adding a legend
legend('data','k=k_0(T_0/T)^a','confidence band');


% ______________________________________________________________
%|                              END                    
%|______________________________________________________________



 
 