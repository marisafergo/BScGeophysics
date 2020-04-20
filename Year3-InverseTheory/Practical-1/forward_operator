function [ d_hat ] = forward_operator( m_trial )
%Inverse Theory - Practical 1: Inversion by trial and error

% ---------------------------------
% Marisabel Gonzalez
% 02/10/2018
% ---------------------------------

clear all
close all
% Clearing figures and command window
%clf
clc


%----------------------------------
% NOMENCLATURE
%----------------------------------

% m_trial: guessed P0 coordinates
% d: data measurements of points P1-P4 (range)
% d_hat: data measurements (range)
% res: residuals of the range
% RSS: Residual sum of squares

% Point Coordinates
x = [110;172;826;698];
y = [-65;423;-143;354];
z = [20;25;40;35];

% Guesses of P0 coordinates x,y,z
m_trial = [352;152;49];

% Observations
d = [370.2;392.8;482.4;360.8];


% Equation relating the coordinates of P0 to the range from P1 
d_hat = [0;0;0;0];
for i=1:4
    d_hat(i) = sqrt (( x(i,1) - m_trial(1) )^2 +( y(i,1) - m_trial(2) )^2 + ( z(i,1) - m_trial(3))^2);   
end

% Ploting x,y positions from P1 to P4
plot(x,y,'bx');

% Plotting guessed x,y coordinates of P0
hold on 
X = m_trial(1,1); 
Y = m_trial(2,1);
plot(X,Y, 'r*');

% Adding a title, labels and a legend
title(' 2D coordinates of the points of measurements')
xlabel('x coordinates')
ylabel('y coordinates')
legend('P1-P4','P0 estimate');

% Computing the range residuals
res = d_hat - d;
RSS = sum(res).^2

end