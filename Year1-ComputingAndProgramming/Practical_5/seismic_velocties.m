% _______________________________________________________________________
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



% USER ENTERS FILENAME CONTAINING THE ELASTIC CONSTANT VALUES
e_c_file = input('Please enter the filename containing the elastic constant values: ', 's');
e_c = load(e_c_file);
disp(' ') % creates a blank line


% USER ENTERS FILENAME CONTAINING THE DENSITY VALUE 
rho = input('Please enter the filename containing density values: ','s');
rho_value = load(rho);
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
v_p = sqrt(((k*10^9)+((4/3)*(g*10^9)))./rho)./10^3;
disp(' ') % creates a blank line



% EXPRESSION THAT EVALUATES SHEAR WAVE VELOCITY (in kms^-1)
v_s = sqrt((g*10^9)./rho)./10^3;
disp(' ') % creates a blank line



% EXPRESSION THAT EVALUATES THE BULK SOUND VELOCITY (in kms^-1)
v_phi = sqrt((k*10^9)./rho)./10^3;
disp(' ') % creates a blank line



% +-----------------------------------------------------------+
% open the file mgsio3.velocities.dat 
% +-----------------------------------------------------------+

fid = fopen('mgsio3.velocities.dat','w');




% +-----------------------------------------------------------+
% write out the results to mgsio3.velocities.dat 
% +-----------------------------------------------------------+

fprintf(fid,'%s %s %s %4.1f %s\n','The compressional wave velocity of', ...
 mineral, 'is:', v_p, 'kms^(-1)');
fprintf(fid,'%s %s %s %4.1f %s\n','The shear wave velocity of', ...
mineral, 'is:', v_s, 'kms^(-1)');
fprintf(fid,'%s %s %s %4.1f %s\n','The bulk sound velocity of', ...
mineral, 'is:', v_phi, 'kms^(-1)');

% +-----------------------------------------------------------+
% close the file mgsio3.velocities.dat 
% +-----------------------------------------------------------+

fclose(fid);



% mineral não está incluido nas letras rochas porque é uma variável
% e não leva num2str(mineral) porque mais acima já  definimos o input
% desta variável como uma string.

% entretanto, para os valores que queremos display precisamos converter o
% numero numa string ou não iria aparecer nada 
% eg. The bulk sound velocity of panzito is:   kms^-1

% as nossas unidades (kms^-1) têm que estar dentro de ' ' porque fazem
% parte do display

% incluimos ([]) porque misturamos commands







