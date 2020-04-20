% Inverse Theory - Practical 2: Inversion by trial and error

% This script computes the seismic velocity of  three different
% layers and the thickness of the upper two

% ---------------------------------
% Marisabel Gonzalez
% 09/10/2018
% ---------------------------------

% Clearing workspace, figures and command window
clear all
close all
clc


%----------------------------------
% NOMENCLATURE
%----------------------------------
% t0: first arrival time [s]
% x: distance from source [m]
% d: vector of observations (time)
% G: forward operator matrix (distance)
% s: slowness (s=1/c)
% ls_line: least square line
% z: layer thickness
% tao = intercection



% Observations
t0 = [0.0474;0.0979;0.1481;0.1949;0.2288;0.2563;0.2819;0.3108;0.3325;0.3529;0.3694];
x = [80;160;240;320;400;480;560;640;720;800;880];

% Plotting time as a function of distance
plot(x,t0, 'o')
title('Time versus distance')
xlabel('Source-receiver distance [m]')
ylabel('Time [s]')

% Observations at the first 4 geophones
d1 = [0.0474;0.0979;0.1481;0.1949];
G1 = [80;160;240;320];


% Estimating c1 from s1
m1 = inv(G1'*G1) * G1'*d1;         
c1 = 1./m1;


% Least square line layer 1
hold on
hline1 = refline(m1,0);
hline1.Color = 'b';


% Observations at the next 4 geophones
d2 = [0.2288;0.2563;0.2819;0.3108];
G2 = [400,1; 480,1; 560,1 ; 640,1];


% Estimating c2 from s2
m2 = inv(G2'*G2) * G2'*d2;      
c2 = 1./m2(1,1);


% Least square line layer 2
hold on
hline2 = refline(m2(1,1),m2(2,1));
hline2.Color = 'r';


% Computing the thickness of the first layer
z1 = ( m2(2,1)./2 )  * ( (c2*c1) / (c2^2 - c1^2)^0.5 );


% Observation at the last 3 geophones
d3 = [0.3325;0.3529;0.3694];
G3 = [720,1; 800,1; 880,1];


% Estimating c3 from s3
m3 = inv(G3'*G3) * G3'*d3;        
c3 = 1./m3(1,1);


% Least square line layer 3
hold on
hline3 = refline(m3(1,1),m3(2,1));
hline3.Color = 'g';
legend('Data Points','Geophones 1-4','Geophones 5-8','Geophones 9-11','Location','NorthWest')


% Computing the thickness of the second layer
A = ( ( ( c3^2 - c1^2 )^0.5 ) / ( c3*c1 ) );
B = ( ( ( c3^2 - c2^2 )^0.5 ) / ( c3*c2 ) );

z2 = ( m3(2,1) - (2*z1*A) ) / (2*B);



%----------------------------------
% END
%----------------------------------




