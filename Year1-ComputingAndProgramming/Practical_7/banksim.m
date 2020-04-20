%          MATLAB script to simulate online banking


% ______________________________________________________________
%|                   Marisabel Gonzalez                         |
%|                       12/03/2017                             |
%|______________________________________________________________|


% +-----------------------------------------------------------+
% | ibid  - internet banking identification                   |
% | pins  - personal identification number (supplied)         |
% | pinf  - personal identification number (on file)          |
% | noss  - mothers maiden name (supplied)                    |
% | nosf  - mothers maiden name (on file)                     |
% | yobs  - year of birth (supplied)                          |
% | yobf  - year of birth (on file)                           |
% | balance - users current account balance                   |
% | ovdrlmt - users agreed overdraft limit                    |
% | ovdrawn - how much the user is overdrawn                  |
% | filename - name of file containing users data             |
% | transfer - amout of money to be transferred               | 
% +-----------------------------------------------------------+


disp('This script simulates online banking:')
disp(' ') % creates a blank line
disp(' ') % creates a blank line


% WELCOME MESSAGE
fprintf('%s\n\n','Welcome to SOEE1160 online banking.')


% ASKS USER FOR ID 
ibid = input('Please enter your internet banking ID:', 's');


% ASKS USER FOR PIN number
pins = input('Please enter your four digit PIN:');




% +-----------------------------------------------------------+
% read in data corresponding to the supplied ID -- stored in
% a file whos name is ID.dat. the format of the file is
%
% row 1 =  PIN number
% row 2 =  users number of siblings 
% row 3 =  users year of birth
% row 4 =  users current account balance 
% row 5 =  users agreed overdraft limit
% +-----------------------------------------------------------+



% CREATES FILENAME
filename = [ibid '.dat'];



% READS DATA ON FILE
fid = fopen(filename,'r');
data = fscanf(fid,'%i',[1 inf]);
fclose(fid);


% ASSIGN VALUES TO MORE USER FRIENDLY VARIABLE NAMES

pinf = data(1);
nosf = data(2);
yobf = data(3);
balance = data(4);
ovdrlmt = data(5);





% ___________________________________________________________________
%    check if PIN matches with that on file -- if not, check that
%    the number of siblings and year of birth match those on file.
%       if so, proceed to transfer money; if not, LOCK ACCOUNT.
% ___________________________________________________________________

if (pins == pinf)
   fprintf('%s\n\n','PIN correct.')
else
   fprintf('%s\n\n','PIN incorrect')
   fprintf('%s\n\n','You will now be asked some security questions.')
   noss = input('Please enter the number of siblings you have:');
   fprintf('\n')
   yobs = input('Please enter the year that you were born:');
   if ((noss == nosf) && (yobs == yobf))
      fprintf('%s\n\n','Number of siblings and year of birth correct.')
   else
      fprintf('%s\n\n','Incorrect answer - account locked.')
      return
   end
end



%____________________________________________________________________
% TELLS USER CURRENT BALANCE AND ASKS HOW MUCH THEY WANT TO TRANSFER
%____________________________________________________________________

fprintf('%s %6.2f\n\n','You current balance is £',balance)
transfer = input('How much money do you wish to transfer? ');
fprintf('\n')
if (transfer <= balance)
   balance = balance - transfer;
   fprintf('%s\n\n','Transfer complete.')
   fprintf('%s %6.2f\n','Your new balance is £',balance) 
elseif (transfer <= (balance + ovdrlmt))
   ovdrawn = balance - transfer;
   balance = balance - transfer;
   fprintf('%s\n\n','Transfer completer.')
   fprintf('%s %6.2f\n','You are now overdrawn by £',ovdrawn) 
else
   fprintf('%s\n\n','Not enough funds available.')
   return
end

%_______________________________________________________________
%               WRITES THE NEW BALANCE TO FILE
%_______________________________________________________________

data(4) = balance;
data = data';
fid = fopen(filename,'w');
fprintf(fid,'%i\n',data);
fclose(fid);
