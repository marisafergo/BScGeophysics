% MATLAB script to read in stresses from a file stress.dat
% and calculate the cumulative average values.  


% ______________________________________________________________
%|                   Marisabel Gonzalez                         |
%|                       15/04/2017                             |
%|______________________________________________________________|


% ______________________________________________________________
%|                         NOMENCLATURE                          
%|______________________________________________________________
%  sdat - file id for stress.dat
%  cave - file id for cumave.dat
%  data - matrix to store data
%  rwcl - stores dimensions of data
%  mnvl - store cumulative average

%_______________________________________________________________


% TELLS USER WHAT THE SCRIPT DOES
fprintf('%s\n','This script reads in the file stress.dat,')
fprintf('%s\n','and calculates cumulative average values.' )
fprintf('%s\n', ' ')


% READ IN THE VALUES FROM stress.dat
data = load('stress.dat');



% OPEN cumave.dat FOR WRITING
cave = fopen('cumave.dat','w');



% DETERMINE NUMBER OF VALUES
rwcl = size(data);



% CHECK MORE THAN 100 DATA POINTS
if (rwcl(1) < 100)
  fprintf('%s %i %s\n','Only',rwcl(1),'values in the file');
  fprintf('%s\n','More than 100 values are required')
  fprintf('%s\n','Terminating exectution');
  return
end



% CALCULATE THE CUMULATIVE AVERAGE
% write headers
fprintf(cave,'%9s %13s\n','Time (fs)','Stress (GPa)');

% loop over all values, in increments of 1000
for i=100:100:rwcl(1)
    
% calculate mean
  mnvl =  mean(data(1:i,2));
  
% write mean to file
  fprintf(cave,'%9i %13.3f\n',i,mnvl);
end

%CLOSE cumave.dat
fclose(cave);

% ______________________________________________________________
%|                              END                    
%|______________________________________________________________
