% +-----------------------------------------------------------+
% | This MATLAB script reads in the output from a molecular   |
% | dynamics simulation and computes and plots the cumulative | 
% | average temperature and its associated error.             |
% |                                                           |
% | The data must be stored in a file in two column vectors:  |
% |                                                           |
% |   column 1 = simulation time (fs)                         | 
% |   column 2 = temperature (K)                              |
% |                                                           |
% | The results are written to the file cumave.dat.           |
% |                                                           |
% | 04/09/2014 - Stephen Stackhouse                           |
% +-----------------------------------------------------------+

% +-----------------------------------------------------------+
% | fnam - name of file containing the data                   |
% | fid1 - file identifier for input file                     |
% | fid2 - file identifier for output file                    |
% | data - array used to store the data                       |
% | cuma - cumulative average                                 |  
% | stdm - standard deviation of mean                         |
% +-----------------------------------------------------------+

% +-----------------------------------------------------------+
% clear command window and all variables
% +-----------------------------------------------------------+

clc
clf
clear all

% +-----------------------------------------------------------+
% tell user what the script does
% +-----------------------------------------------------------+

fprintf('%60s\n','+----------------------------------------------------------+');
fprintf('%60s\n',' This MATLAB script reads in the output from a molecular    ');
fprintf('%60s\n',' dynamics simulation and computes and plots the cumulative  ');
fprintf('%60s\n',' average temperature and its associated error.              ');
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

fnam = input(' Please give the name of the file containing the data: ', 's');

%fnam = 'temp.dat';

% +-----------------------------------------------------------+
% open file containing values 
% +-----------------------------------------------------------+

fid1=fopen(fnam,'r');
data = fscanf(fid1, '%f',[2 inf]);
fclose(fid1);

% +-----------------------------------------------------------+
% reorientate data so it matches file
% +-----------------------------------------------------------+

data = data';

% +-----------------------------------------------------------+
% caclulate cumulative average and associated error
% +-----------------------------------------------------------+

for i=1:1:length(data)
  cuma(i) = mean(data(1:i,2));
  stdm(i) = std(data(1:i,2))/sqrt(i);
end

% +-----------------------------------------------------------+
% write the results to the file cumave.dat
% +-----------------------------------------------------------+

fid2=fopen('cumave.dat','w');
fprintf(fid2,'%12s %12s %12s\n', 'time (fs)','cum. ave. (K)','error (K)');
fprintf(fid2,'%12i %12.0f %12.0f\n', [data(:,1)'; cuma; stdm]);
fclose(fid2);

% +-----------------------------------------------------------+
% plot the cumulative average 
% +-----------------------------------------------------------+

plot(data(:,1),cuma,'r-')
hold on

% +-----------------------------------------------------------+
% plot the error bands
% +-----------------------------------------------------------+

plot(data(:,1),(cuma+stdm),'g-')
plot(data(:,1),(cuma-stdm),'g-')
axis([0 4000 3800 4200]);

% +-----------------------------------------------------------+
% add title, axis labels and legend
% +-----------------------------------------------------------+

title('plot of the cumulative average of the temperature')
xlabel('simulation length (fs)')
ylabel('temperature (K)')
legend('cumulative average','confidence band (1 sigma)')

% +-----------------------------------------------------------+
