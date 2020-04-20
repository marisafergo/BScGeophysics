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



% EXPRESSION TO EVALUATE BULK MODULUS (in GPa)
k = (1/9).*(e_c(1)+e_c(2)+e_c(3) ...
+2.*(e_c(4)+e_c(5)+e_c(6)));
disp(' ') % creates a blank line



% EXPRESSION TO EVALUATE SHEAR MODULUS (in GPa)
g = (1/15).*(e_c(1)+e_c(2)+e_c(3)...
-(e_c(4)+e_c(5)+e_c(6))...
+3.*(e_c(7)+e_c(8)+e_c(9)));
disp(' ') % creates a blank line



% EXPRESSION THAT EVALUATES THE COMPRESSIONAL WAVE VELOCITY (in kms^-1)
v_p = sqrt(((k*10^9)+((4/3)*(g*10^9)))/rho)/10^3;
disp(' ') % creates a blank line



% EXPRESSION THAT EVALUATES SHEAR WAVE VELOCITY (in kms^-1)
v_s = sqrt((g*10^9)/rho)/10^3;
disp(' ') % creates a blank line



% EXPRESSION THAT EVALUATES THE BULK SOUND VELOCITY (in kms^-1)
v_phi = sqrt((k*10^9)/rho)/10^3;
disp(' ') % creates a blank line


% FINAL RESULTS (DISPLAY)
disp(['The compressional wave velocity of ' mineral ' is:' ...
 num2str(v_p) 'kms^-1'])
disp(['The shear wave velocity of ' mineral ' is: ' ...
 num2str(v_s) ' kms^-1'])
disp(['The bulk sound velocity of ' mineral ' is: ' ... 
 num2str(v_phi) ' kms^-1'])



% mineral não está incluido nas letras rochas porque é uma variável
% e não leva num2str(mineral) porque mais acima já  definimos o input
% desta variável como uma string.

% entretanto, para os valores que queremos display precisamos converter o
% numero numa string ou não iria aparecer nada 
% eg. The bulk sound velocity of panzito is:   kms^-1

% as nossas unidades (kms^-1) têm que estar dentro de ' ' porque fazem
% parte do display

% incluimos ([]) porque misturamos commands







