% PRACTICAL 3_p2

% ______________________________________________________________
%|                   Marisabel and Abdullah                     |
%|                       03/03/2017                             |
%|______________________________________________________________|

clear all
clc
clf


disp(['This script calculates the cumulative average of the temperature'...
     ' and its associated error from a file called temp.dat']),
disp(' '); %blank line


% ______________________________________________________________
%|                         NOMENCLATURE                          
%|______________________________________________________________

% m = array storing the data from "temp.dat"
% fs = simulation time (fs)
% T = temperature (k)
% t = size array T
% fs_s = size array fs
% mn = mean of the cumulative average
% stdev = standard deviation
% stdmn = standard deviation of the mean
% mn+stdmn = maximum uncertainties
% mn-stdmn = minumum uncertainties 



% ______________________________________________________________
%|                         PART 2                                
%|______________________________________________________________

%TASK 1: READING THE VALUES FROM "temp.dat"

fid1 = fopen('temp.dat', 'r');   %opening file
format = '%i %f';
m = fscanf(fid1,format, [2 inf]); %reading the file
m = m'; %calculating the transpose (we are using fscanf)
fclose(fid1); % closing file




%TASK 2: CALCULATING THE CUMULATIVE AVERAGE OF THE TEMPERATURE

fs = m(:,1);
T = m(:,2);

t = size(T);
fs_s = size(fs);
sm = 0;

for i=1:1:fs_s(1)   
    sm = sm + m(i,2); %cumulative sum
    mn(i) = sm/i; %calculating the mean for cumulative average
    stdev(i) = std(T(1:i)); %calculating the standard deviation
    stdmn(i) = stdev(i)/sqrt(i); %calculating the standard deviation of the mean
end 
    



%TASK 3: PLOTTING

hold on   % allows to plot multiple data sets
 
% Plotting the values
plot(fs,mn,'r-', fs,mn+stdmn,'g-', fs,mn-stdmn,'g-');

% Adding a legend
legend('cumulative average', 'confidence band (1 sigma)');

% Adding title and axis labels
title('Cumulative average of the temperature and its associated error');
xlabel('simulation lenght (fs)');                    
ylabel('temperature (K)');  




%TASK 4: Writing the values to a file called cumave.dat

fid2 = fopen('cumave.dat','w'); %creating the file for writing


% Writing headers
fprintf(fid2,'%25s %25s %25s\n','Cumulative average(K)','Min Uncertainty(K)',...
    'Max Uncertainty(K)');

% Write values to file
fprintf(fid2,'%26.3f %26.3f %26.3f\n',mn,mn-stdmn,mn+stdmn);


fclose(fid2); %closing file

% ______________________________________________________________
%|                              END                    
%|______________________________________________________________


    