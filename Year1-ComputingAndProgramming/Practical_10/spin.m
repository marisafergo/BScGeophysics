% MATLAB script that reads in the values from h.dat, calculates
% the value of n(P,T) over a range of temperatures and pressures
% and plots them using MATLAB function pcolour


% ______________________________________________________________
%|                   Marisabel Gonzalez                         |
%|                       03/03/2017                             | 
%|______________________________________________________________|


% ______________________________________________________________
%|                         NOMENCLATURE                          
%|______________________________________________________________

% n: Fraction of iron in a low-spin state
% P: Pressure (in GPa)
% T: Temperature (in K)
% m: Orbital degeneracy of the high-spin state ( with value of 3)
% S: Total spin quantum number (with value of 2)
% Xfe: Fraction of iron in the phases ( with value of 0.1875)
% H: Difference in enthalpy between the high-and-low-spin states
% Kb: Boltzmann's constant (1.38064852 × 10-23 m2 kg s-2 K-1)

%________________________________________________________________


%this script does nhoco bonhonho

% OPEN FILE FOR READING
fid = fopen('h.dat' ,'r');  



% THIS COMMAND READS THE DATA FROM THE FILES INTO MATRICES
format1 = '%f %f';
h = fscanf(fid, format1, [2 inf]);



% CALCULATING THE TRANSPONSE (as fscanf rearranges rows into columns)
h = h';



% CLOSING ALL OPEN FILES
fclose(fid);



% ______________________________________________________________
%|                    PLOTTING THE DATA                             
%|______________________________________________________________

% THIS COMMANDS ALLOWS MULTIPLE PLOTS
 hold on

% PLOTTING X-axis AND Y-axis
plot(h(:,1),h(:,2))

% ADDING TITLE AND AXIS LABELS
title('Plot of the fraction of low-spin iron in FeMgO in the lower mantle')
xlabel('Pressure (GPa)')                    
ylabel('Temperature (K)') 


% LINE OF BEST FIT (fit third order polynomial)
bf = polyfit(h(:,1),h(:,2),3);   %cubic fit 

% yfit = polyval(bf,h(:,2));       %calculate y-values
% 
% plot(h(:,2),yfit,'k-')           % plot values black solid line

% ______________________________________________________________
%|                       EVALUATING n                        
%|______________________________________________________________

% Fixed values
m = 3;
S = 2;
Xfe = 0.1875;
Kb = 1.38064852e-23;

 for T= 300:400
    for P= 1e+9:140e+9
        
        n = 1/(1+m(2*S+1)*exp(H*P/Kb*Xfe*T));  % Expression to evaluate n
        pcolor(bf)
    end
 end 
 

 
    




