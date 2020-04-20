%  _______________________________________________________________________
% |                                                                       |
% |"Matlab Script to calculate seismic velocities from elastic constants" | 
% |                      Marisabel Gonzalez 01/03/2017                    | 
% |_______________________________________________________________________|


%  ___________________________________________________________
% | mineral - name of the mineral to which value correspond   |
% | e_c - elastic constants                                   |
% | rho - density                                             |
% | k - bulk modulus                                          |
% | g - shear modulus                                         |
% | v_s - shear wave velocity                                 |
% | v_p - compressional wave velocity                         |
% | v_phi - bulk sound velocity                               |
% |___________________________________________________________|


% _____________________________
% |Note that:                  |
% |GPa = 10^9 Pa               |
% |       = 10^9 Nm^-3         |
% |       = 10^9 kg ms^-2 m^-3 | 
% |       = 10^9 kg m^-2s^-2   |
% |____________________________| 




disp('This script calculates seismic velocities from elastic constants:')
disp(' ') % creates a blank line
disp(' ') % creates a blank line



% USER ENTERS THE MINERAL OF INTEREST
mineral = input('please enter the name of the mineral: ', 's');
disp(' ') % creates a blank line



% USER ENTERS THE ELASTIC CONSTANT VALUES
e_c(1)=input('Please enter the value of c11 (in GPa): ');
e_c(2)=input('Please enter the value of c22 (in GPa): ');
e_c(3)=input('Please enter the value of c33 (in GPa): ');
e_c(4)=input('Please enter the value of c12 (in GPa): ');
e_c(5)=input('Please enter the value of c13 (in GPa): ');
e_c(6)=input('Please enter the value of c23 (in GPa): ');
e_c(7)=input('Please enter the value of c44 (in GPa): ');
e_c(8)=input('Please enter the value of c55 (in GPa): ');
e_c(9)=input('Please enter the value of c66 (in GPa): ');
disp(' ') % creates a blank line


% USER ENTERS THE DENSITY VALUE 
rho=input('Please enter the density (in kgm-3): ');
disp(' ') % creates a blank line


%_______________________________________________________________
% CALL BULKMOD_F TO EVALUATE BULK MODULUS (in GPa)
%_______________________________________________________________

[k] = bulkmod_f(e_c);


%_______________________________________________________________
% CALL SHEARMOD_F TO EVALUATE BULK MODULUS (in GPa)
%_______________________________________________________________

[g] = shearmod_f(e_c);



%_______________________________________________________________
% CALL VELOCITIES_F TO EVALUATE BULK MODULUS (in GPa)
%_______________________________________________________________

[v_p, v_s, v_phi] = velocities_f(k,g,rho);

%output variables are separeted by comas




% FINAL RESULTS (DISPLAY)
disp(['The compressional wave velocity of ' mineral ' is:' ...
 num2str(v_p) 'kms^-1'])
disp(['The shear wave velocity of ' mineral ' is: ' ...
 num2str(v_s) ' kms^-1'])
disp(['The bulk sound velocity of ' mineral ' is: ' ... 
 num2str(v_phi) ' kms^-1'])









