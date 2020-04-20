%  _______________________________________________________________________
% |                                                                       |
% |        " Matlab script to calculate the mean, standard deviation      |
% |                 and standard deviation of six numbers.  "             | 
% |                      Marisabel Gonzalez 01/03/2017                    | 
% |_______________________________________________________________________|


% +-----------------------------------------------------------+
% | n1,n2,n3,n4,n5,n6 are the numbers supplied by the user    |
% | sm is the sum of the six numbers                          |
% | mn is the mean                                            |
% | stdev is the standard devation                            |
% | stdmn is the standard devation of the mean                |
% +-----------------------------------------------------------+



disp(['SCRIPT TO CALCULATE THE MEAN, STANDARD DEVIATION' ...
'AND STANDARD DEVIATION OF SIX NUMBERS'])
disp(' ') %blank line



% SETTING sm TO ZERO TO BE ABLE TO USE THE ASSIGNMENT OPERATOR (=)
sm = 0;



% USER PROVIDES SIX NUMBERS
n1 = input('please enter number 1: ');
sm = sm + n1;
n2 = input('please enter number 2: ');
sm = sm + n2;
n3 = input('please enter number 3: ');
sm = sm + n3;
n4 = input('please enter number 4: ');
sm = sm + n4;
n5 = input('please enter number 5: ');
sm = sm + n5;
n6 = input('please enter number 6: ');
disp(' ') %blank space



% EXPRESSION TO CALCULATE THE MEAN VALUE 
mn = sm/6;


% EXPRESSION TO CALCULATE THE STANDARD DEVIATION
% ( using std command and supplying the values as a row vector)
stdev = std([n1 n2 n3 n4 n5 n6]);



% EXPRESSION TO CALCULATE THE STANDARD DEVIATION OF THE MEAN
stdmn = stdev/sqrt(6);



% FINAL RESULTS SHOWN ON SCREEN
disp(['The mean value is: ' num2str(mn)])
disp(['The standard deviation is: ' num2str(stdev)])
disp(['The standard deviation of the mean is: ' num2str(stdmn)])