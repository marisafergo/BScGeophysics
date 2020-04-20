% +-----------------------------------------------------------+
% | This MATLAB script reads in the output from a molecular   | 
% | dynamics simulation and calculates the temperature        |
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
fprintf('%60s\n',' dynamics simulation and calculates the temperature         ');
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
% find min and max values
% +-----------------------------------------------------------+

minval = min(data(:,2));
maxval = max(data(:,2));

% +-----------------------------------------------------------+
% calculate the bin width
% +-----------------------------------------------------------+

bwidth = (maxval-minval)/nbin;

% +-----------------------------------------------------------+
% assign initial values for lower and upper bounds 
% +-----------------------------------------------------------+

lb = minval;
ub = minval+bwidth;

% +-----------------------------------------------------------+
% loop over each bin, and determine how many values lie
% within the stipulated range
% +-----------------------------------------------------------+

% loop over each bin
for i=1:1:nbin
  bin(i) = 0;
  % accounts for > not being >= below
  if (i == 1)
    bin(1) = 1; 
  end
  % loop over each value
  for j=1:1:length(data)
    % if value lies within lower and upper bound
    if ((data(j,2) > lb) && (data(j,2) <= ub))
      bin(i) = bin(i) + 1;
    end
  end 
% calculate mid-point of bin
  midp(i) = (lb + ub)/2;
% increment upper and lower bounds for the bin
  lb = lb + bwidth;
  ub = ub + bwidth;
end

% +-----------------------------------------------------------+
% plot results 
% +-----------------------------------------------------------+

plot(midp,bin,'bo-')
xlabel('temperature (K)');
ylabel('frequency');
title(['distribution of temperature values (' num2str(nbin) ' bins)'])

% +-----------------------------------------------------------+
