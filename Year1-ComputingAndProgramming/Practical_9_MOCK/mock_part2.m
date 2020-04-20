 % MATLAB script to read in measurements calculated stresses
% and plot them as a function of time.


% ______________________________________________________________
%|                   Marisabel Gonzalez                         |
%|                       15/04/2017                             |
%|______________________________________________________________|



% ______________________________________________________________
%|                         NOMENCLATURE                          
%|______________________________________________________________

% data - matrix to store data
% area - store area selected by the user
% rwcl - stores dimensions of data
% sm - stores sum 
% nv - store number of values 
% filename - store the filename for output file 

% _______________________________________________________________



% TELLS USER WHAT THE SCRIPT DOES
fprintf('%s\n','This script reads in calculated stresses,')  
fprintf('%s\n','and plots them as a function of time.' ) 


% OPEN FILE FOR READING
fid = fopen('stress3d.dat','r');
data = fscanf(fid,'%i %f %f %f',[4 inf]); 
fclose(fid);
data = data';



% ______________________________________________________________
%|                       PLOTTING DATA                           
%|______________________________________________________________

% PLOT XX STRESS COMPONENT
subplot(3,1,1)
plot(data(:,1),data(:,2),'r-')
xlabel('Simulation Time (fs)');
ylabel('Calculated Stress (GPa)');
title('Plot of XX Stress Component against Simulation Time')


% PLOT YY STRESS COMPONENT
subplot(3,1,2)
plot(data(:,1),data(:,3),'r-')
xlabel('Simulation Time (fs)');
ylabel('Calculated Stress (GPa)');
title('Plot of YY Stress Component against Simulation Time')


% PLOT ZZ STRESS COMPONENT
subplot(3,1,3)
plot(data(:,1),data(:,4),'r-')
xlabel('Simulation Time (fs)');
ylabel('Calculated Stress (GPa)');
title('Plot of ZZ Stress Component against Simulation Time')

% ______________________________________________________________
%|                              END                    
%|______________________________________________________________
