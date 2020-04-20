% MATLAB script to read in stresses from a file stress.dat
% and calculate the cumulative average values.  


% ______________________________________________________________
%|                   Marisabel Gonzalez                         |
%|                       15/04/2017                             |
%|______________________________________________________________|


% ______________________________________________________________
%|                         NOMENCLATURE                          
%|______________________________________________________________

% sdat - file id for stress.dat
% cave - file id for cumave.dat
% data - matrix to store data
% rwcl - stores dimensions of data
% mnvl - store cumulative average
% ______________________________________________________________


%TELLS USER WHAT SCRIPT DOES
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
% loop over all values
sm = 0;
nv = 0;
for i=1:1:rwcl(1)
% calculate sum of values
  sm = sm + data(i,2);
% nv is used to count off 100 values
  nv = nv + 1;
% once 100 values have been added together calculate mean
  if (nv == 100)
    fprintf(cave,'%9i %13.3f\n',i,sm/i);
% reset nv ready to count off another 100 values
    nv = 0;
  end
end

%CLOSE cumave.dat
fclose(cave);

% ______________________________________________________________
%|                              END                    
%|______________________________________________________________