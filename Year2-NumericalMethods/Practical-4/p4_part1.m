% PRACTICAL 4
% Part 1

% This MATLAB script computes the best value of "a" and its
% associated error by converting the values provided in the file
% "data" into their natural logarithms and use weighted
% least-squares fitting to fit the data.


% ______________________________________________________________
%|                   Marisabel and Abdullah                     |
%|                       16/10/2017                             |
%|______________________________________________________________|

%Clearing the workspace, figures and the command window
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
disp('This MATLAB script computes the best value of "a" and its')
disp('associated error by converting the values provided in the file')
disp('"data" into their natural logarithms and use weighted')
disp('least-squares fitting to fit the data')

disp(' ') %blank line



% TASK 1: reding in values from file and loading them into individual
%column vectors
values = importdata('data');
t = values(:,1);
k = values(:,2);
sigk = values(:,3);


% TASK 2: producing x, y and sigy

%given values
to = 300;    
ko = 52.3;    

% converting values to logarithms owing to simplify solving the equation
% for the unkwonw exponent "a"
x = log(to./t);
y = log(k);
sigy = sigk./k;


% TASK 3: creating and calling function p4_function
disp('Calling the function "p4_function" which performed weighted')
disp('linear least-squares fitting of any set of x, y and sigmay values.')
disp(' ') %blank line

[A,sigA,B,sigB] = p4_function(x,y,sigy);


% TASK 4: plotting the values

hold on  % this command allows multiple plotting


yf = A + B.*x;             % linear function

plot_1 = plot(x,yf,'r-');     % plotting the function 
plot_2 = plot(x,y,'bo');      % plotting of the data
errorbar(x,y,sigy,'bo');      % and its associated error bars


hold off % this commands stops multiple plotting


% Adding title and axis labels
title('plot of y against x')
xlabel('x')                    
ylabel('y')  

% Adding a legend
legend('fit', 'data');


% TASK 5: Displaying on screen our best value of a
disp(['The best value of "a" obtained is: ' num2str(B) ]);



% ______________________________________________________________
%|                              END                    
%|______________________________________________________________


 
 