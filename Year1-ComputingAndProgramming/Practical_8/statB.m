%  _______________________________________________________________________
% |                                                                       |
% |        " Matlab script to calculate the mean, standard deviation      |
% |            and standard deviation of a given number of values.  "     | 
% |                      Marisabel Gonzalez 01/03/2017                    | 
% |_______________________________________________________________________|


% +-----------------------------------------------------------+
% | n number of values supplied by the user                   |
% | sm is the sum of n                                        |
% | mn is the mean                                            |
% | stdev is the standard devation                            |
% | stdmn is the standard devation of the mean                |
% +-----------------------------------------------------------+



disp(['SCRIPT TO CALCULATE THE MEAN, STANDARD DEVIATION' ...
'AND STANDARD DEVIATION OF A GIVEN VALUE OF NUMBERS'])
disp(' ') %blank line


% ______________________________________________________________
%|     Loop to ask the user for the values and read them into
%|               a vector, and calculate their sum
%|______________________________________________________________

sm = 0;
n = input ('Please input the number of values: ');


% if number of values is less than or equal to three,
% warn the user that the results may not be meaningful
% and ask them if they want to continue. 


if (n <= 3)
  fprintf('%s\n','Such a small data set may not produce')
  fprintf('%s\n','meaningful results.')
  fprintf('\n')
  yesno = input('Do you want to continue (yes/no): ','s'); 
  fprintf('\n')
  if (strcmp(yesno,'no'))
     return
  end
end


for i = 1:1:n
    inputnum(i) = input (['Please enter value ' num2str(i) ': ' ]);
    sm = sm + inputnum(i); 
    
end 


 % esse variavel(i) vai guardar o valor de i sem muda-lo 
 % se nao tivessemos isso iria optar pelos diferentes valores de n

 
 
mn = sm/n;       % evaluating the mean
stdev = std(inputnum); % evaluating the standard deviation
stdmn = stdev/sqrt(n); % evaluating the standard deviation of the mean







% FINAL RESULTS SHOWN ON SCREEN
% disp(['The mean value is: ' num2str(mn)])
% disp(['The standard deviation is: ' num2str(stdev)])
% disp(['The standard deviation of the mean is: ' num2str(stdmn)])


%ou 


fprintf('\n')
fprintf('%s %8.4f','The mean value is: ',mn)
fprintf('%s %8.4f\n','The standard deviation is: ',stdev)
fprintf('%s %8.4f\n','The standard deviation of the mean is:', stdmn)


