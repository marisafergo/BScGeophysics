% LAB 3
% HEAT FLOW AND THE DEPTH OF THE OCEAN FLOOR

% ______________________________________________________________
%|                   Marisabel Gonzalez                         |
%|                       xx/03/2018                             |
%|______________________________________________________________|

% These commands clear the command window, the workspace and any
% existent figure (user can uncomment if desire)
% clc
% clear all
% clf


% ----------------------------------------------------------------------
%                         NOMENCLATURE                          
% ----------------------------------------------------------------------

% t = Nx1 column vector containing ages at which to calculate w [Ma]
% params_hs.rhom = density of the mantle [ 3300 kg m^(-3)]
% params_hs.rhow = density of seawater [ 1025 kg m^(-3)]
% params_hs.alphav = volumetric coeff. of thermal expansion for mantle 
%                    3.1e-5 [K^-1]
% params_hs.Tm = Temperature of the mantle 1300*274.15  [K]
% params_hs.T0 = Temperature of seawater 0*273.15 [K]
% [note that it is the difference between Tm and T0 that is important]
% params_hs.kappa = thermal diffusivity 0.8e-6 [m^2 s^(-1)]
% params_hs.ridge_depth = elevation of ridge [m]  [e.g. -2000 or -2500]

% params_plate.yL = thickness of old lithosphere [m]
% params_plate.n = number of terms in infinite series to use.


% include display for user about the script purpose



% Adding mbin to the path
addpath mbin


%---------------------------------------------------------------------
%             ****   TASK 1: The analytical model   **** 
%---------------------------------------------------------------------

% Setting values for each parameter of the depth of the half-space 
% and of the plate
t = [0:250];             
params_hs.rhom = 3300;
params_hs.rhow = 1025;
params_hs.alphav = 3.1e-5;
params_hs.Tm = 1300*274.15;
params_hs.T0 = 0*273.15;
params_hs.kappa = 0.8e-6;
params_hs.ridge_depth = -2000; % assumed value [e.g. -2000 or -2500]

params_plate = params_hs;      % this command equals the parameters
                               % of both structures

params_plate.yL = 200000;      % thickness of old lithosphere [m] 
                               % assumed value



%-------------------------------------------------------------------------
% Plot of depth vs age for both models
%-------------------------------------------------------------------------

% PS: Two values of params_plate.n were assumed owing to see the influence
% of a greater and smaller value
 
params_plate.n = 5000;       
                               
% Calling the functions depth_halfspace.m and depth_plate.m that enable
% the calculation of w as a function of age                           
[depth1] = depth_plate(t,params_plate);
[depth2] = depth_halfspace(t,params_hs);
 
 
hold on                        % this command allows multiple plotting 
figure(1)
subplot(2,2,1)
plot(t,depth1,'r-','linewidth',2);

hold on                        % this command allows multiple plotting 
plot(t,depth2,'g--','linewidth',2);

% Adding title and axis labels
title('Ocean depth versus age');
xlabel('Age [Ma]');                    
ylabel('Depth [m]');  
                       

params_plate.n = 5;      
                             
% Calling the functions depth_halfspace.m and depth_plate.m that enable
% the calculation of w as a function of age                                 
[depth1] = depth_plate(t,params_plate);
[depth2] = depth_halfspace(t,params_hs);     
 
                              
subplot(2,2,2)
plot(t,depth1,'r-','linewidth',2);

hold on             % this command allows multiple plotting
plot(t,depth2,'g--','linewidth',2);

% Adding title and axis labels
title('Ocean depth versus age');
xlabel('Age [Ma]');                    
ylabel('Depth [m]');  


%-------------------------------------------------------------------------
% Plot of depth vs sqrt(age) for both models
%-------------------------------------------------------------------------

% PS: Two values of params_plate.n were assumed owing to see the influence
% of a greater and smaller value

params_plate.n = 5000;        

% Calling the functions depth_halfspace.m and depth_plate.m that enable
% the calculation of w as a function of age   
[depth1] = depth_plate(t,params_plate);
[depth2] = depth_halfspace(t,params_hs);
 
 
hold on                        % this command allows multiple plotting 
subplot(2,2,3)
plot(sqrt(t),depth1,'r-','linewidth',2);

hold on                        % this command allows multiple plotting 
plot(sqrt(t),depth2,'g--','linewidth',2);

% Adding title and axis labels
title('Ocean depth versus age');
xlabel('Age [Ma]');                    
ylabel('Depth [m]');  
                       


params_plate.n = 5;          
                             
% Calling the functions depth_halfspace.m and depth_plate.m that enable
% the calculation of w as a function of age   
[depth1] = depth_plate(t,params_plate);
[depth2] = depth_halfspace(t,params_hs);   
 
                              
subplot(2,2,4)
plot(sqrt(t),depth1,'r-','linewidth',2);

hold on                       % this command allows multiple plotting
plot(sqrt(t),depth2,'g--','linewidth',2);

% Adding title and axis labels
title('Ocean depth versus sqrt(age)');
xlabel('sqrt(Age) [Ma]');                    
ylabel('Depth [m]');     



%---------------------------------------------------------------------
%    **** TASK 2: Comparing the models with real depth age data **** 
%---------------------------------------------------------------------


% This command shows the images and loads the grids into memory (edit)

figure(2)
% subplot(1,2,1)
elev = show_ers('elevation_northatlantic');

% Adding title and axis labels
title('Elevation of North Atlantic')
xlabel('Latitude')
ylabel('Longitude')

hold on                       % this command allows multiple plotting
% subplot(1,2,2)
figure(3)
age = show_ers('age_northatlantic');
title('Age of North Atlantic')
xlabel('Latitude')
ylabel('Longitude')


% delete('profdef.dat');        % this command deletes the file profdef.dat 
%                               % from disk owing to be able to select a  
%                               % new profile


% This command extracts depth and age profiles from the real data
[prof_depth] = main_prof('elevation_northatlantic',50);
[prof_age] = main_prof('age_northatlantic',50);

%-------------------------------------------------------------------------
% Plot of depth vs (age) for a representative profile
%-------------------------------------------------------------------------
% 
% plot (t,depth1)
% hold on
% plot (t,depth2)
% xlabel('age (seconds)')
% ylabel('depth')
% title('Depth vs age')
% legend('data profile of north atlantic', 'halfspace', 'plate model')



