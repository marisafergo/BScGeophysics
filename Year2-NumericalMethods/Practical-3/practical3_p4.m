% PRACTICAL 3_p4

% ______________________________________________________________
%|                   Marisabel and Abdullah                     |
%|                       03/03/2017                             |
%|______________________________________________________________|

clear all
clc
clf

disp(['This script calculates and plots the frequency distribution' ...
    ' of the temperature, for a specified number of bins using histfit'])
disp(' '); %blank line

% ______________________________________________________________
%|                         NOMENCLATURE                          
%|______________________________________________________________
% m = array storing the data from "temp.dat"
% bins = number of bins provided by user
% T = temperature (k)
% t = size array T
% min_T = minimum T value
% max_T = maximum T value
% bw = bin width
% lb = lower error band
% up = upper error band
% f_dist = frequency distribution
% m_bw = mean bin width value
% count = number of T values laying in a particular bin
% count_l = length array count

% ______________________________________________________________
%|                          PART IV                     
%|______________________________________________________________

%TASK 1: Reading the values from "temp.dat"

fid = fopen('temp.dat', 'r');   %opening file
format = '%i %f';
m = fscanf(fid,format, [2 inf]); %reading the file
m = m'; %calculating the transpose (we are using fscanf)
fclose(fid); % closing file


%TASK 2: Asking user number of bins to use
bins = input('Please type the number of bins to use: ');

%TASK 3: Calculating the bin width
T = m(:,2);
t = size(T);

min_T = min(T);
max_T = max(T);

bw = (max_T - min_T)/bins; %equation for the bin width

lb = min(T);
ub = min(T) + bw;


for i =1:1:bins        %loop over each bin provided by the user
    count(i) = 0;      
    for j =1:1:t(1)    %loop over every T value
        if   (T(j) >= lb && T(j) <= ub) % determining if T value lies on current bin
            count(i) = count(i) + 1; %counting T values on each bin 
        end        
    end
    m_bw(i) = (lb+ub)/2; %mid-point of each bin
    lb = ub; 
    ub = lb + bw; %ub replaces the previous lb shifting the bin position
end



% TASK 4: Plotting frequency against the mid-point of each bin

hold on   % allows to plot multiple data sets



% Plotting the values in a histogram
count_l = length(count);
 
histfit(T,count_l);



% Adding title and axis labels
title('Distribution of temperatre values')
xlabel('temperature (K)')                    
ylabel('frequency')  


% ______________________________________________________________
%|                              END                    
%|______________________________________________________________
