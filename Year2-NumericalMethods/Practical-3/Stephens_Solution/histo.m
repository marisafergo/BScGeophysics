% +-----------------------------------------------------------+
% | This MATLAB script reads in the output from a molecular   | 
% | dynamics simulation and plots the temperature             |
% | distribution using a user supplied number of bins.        |
% |                                                           |
% | The data must be stored in a file in two column vectors:  |
% |                                                           |
% |   column 1 = simulation time (fs)                         |
% |   column 2 = temperature (K)                              |
% |                                                           |
% | 04/09/2014 - Stephen Stackhouse                           |
% +-----------------------------------------------------------+

% +-----------------------------------------------------------+
% | fnam - name of file containing the data                   |
% | data - array used to store the data                       |
% | nbin - number of bins                                     |
% | minval - minimum temperature value                        |
% | maxval - maximum temperature value                        |
% | bwidth - bin width                                        |
% | lb - lower bound for bin                                  |
% | ub - upper bound for bin                                  | 
% | bin - stores number of values  in each bin                | 
% | midp - stores mid-point of bins                           |
% +-----------------------------------------------------------+

clc
clf
clear all

% +-----------------------------------------------------------+
% tell the user what the script does
% +-----------------------------------------------------------+

fprintf('%60s\n','+----------------------------------------------------------+');
fprintf('%60s\n',' This MATLAB script reads in the output from a molecular    ');
fprintf('%60s\n',' dynamics simulation and plot the temperature               ');
fprintf('%60s\n',' distribution using a user supplied number of bins.         ');
fprintf('%60s\n','                                                            ');
fprintf('%60s\n',' The data must be stored in a file in two column vectors:   ');
fprintf('%60s\n','                                                            ');
fprintf('%60s\n','   column 1 = simulation time (fs)                          ');
fprintf('%60s\n','   column 2 = temperature (K)                               ');
fprintf('%60s\n','                                                            ');
fprintf('%60s\n',' The results are written to the file cumave.dat.            ');
fprintf('%60s\n','+----------------------------------------------------------+');

% +-----------------------------------------------------------+
% ask user for the input file
% +-----------------------------------------------------------+

fnam = input('Please give the name of the file containing the data: ', 's');
fprintf(' \n');

% +-----------------------------------------------------------+
% ask user for the number of bins to use 
% +-----------------------------------------------------------+

nbin = input('Please enter the number of bins to use: ');
fprintf(' \n');

% +-----------------------------------------------------------+
% open file containing values 
% +-----------------------------------------------------------+

fid=fopen(fnam);
data = fscanf(fid, '%f',[2 inf]);
fclose(fid);

% +-----------------------------------------------------------+
% reorientate data so it matches file
% +-----------------------------------------------------------+

data = data';

% +-----------------------------------------------------------+
% plot results 
% +-----------------------------------------------------------+

histfit(data(:,2),nbin)
xlabel('temperature (K)');
ylabel('frequency');
title(['distribution of temperature values (' num2str(nbin) ' bins)'])

% +-----------------------------------------------------------+
