% MATLAB SCRIPT TO READ THE SEA LEVEL ANOMALIES
% MADE BY TOPEX AND JASON ALIMETER MISSIONS



                        
% MORE INFORMATION CAN BE FOUND IN THE FOLLOWING LINKS                                                           
% http://sealevel.colorado.edu/                              
% http://sealevel.colorado.edu/files/2014_rel1/sl_global.txt


% ______________________________________________________________
%|                   Marisabel Gonzalez                         |
%|                       03/03/2017                             |
%|______________________________________________________________|


% _____________________________________________________________
% |                   VARIABLE NOMENCLATURE                   |
% |                                                           |
% | TOPEX - matrix to store data from TOPEX.dat               |
% | JASON1 - matrix to store data from Jason-1.dat            |
% | JASON2 - matrix to store data from Jason-2.dat            |
% | T - stores the file identifier for TOPEX.dat              |
% | J1 - stores the file identifier for Jason-1.dat           |
% | J2 - stores the file identifier for Jason-2.dat           |
% | combined - matrix to store combined data set              |
% | a - stores polynomial coefficients from fitting procedure |
% | yfit - matrix containing calculated y value for the fit   |
% +-----------------------------------------------------------+


disp ('READING SEA LEVEL ANOMALIES FROM TOPEX AND ALIMETER MISSIONS')
disp (' ') %blank line



% THIS COMMAND OPEN THE FILES TOPEX.dat, Jason-1 and Jason-2.dat 
% FOR READING

T = fopen('TOPEX.dat', 'r');
J1 = fopen('Jason-1.dat', 'r');
J2 = fopen('Jason-2.dat', 'r');




% THIS COMMAND READS THE DATA FROM THE FILES INTO MATRICES
TOPEX = fscanf(T,'%f %f',[2 inf]);
JASON1 = fscanf(J1,'%f %f',[2 inf]);
JASON2 = fscanf(J2,'%f %f',[2 inf]);




% CALCULATING THE TRANSPONSE (as fscanf rearranges rows into columns)
TOPEX = TOPEX';
JASON1 = JASON1';
JASON2 = JASON2';




% THIS COMMANDS ALLOWS MULTIPLE PLOTS
hold on



% PLOTTING THE DATA
plot(TOPEX(:,1),TOPEX(:,2),'ro');
plot(JASON1(:,1),JASON1(:,2),'gs');
plot(JASON2(:,1),JASON2(:,2),'y^');


% SETTING THE SCALE
axis([1993 2014 -20 80])



% COMBINES THE THREE DATA SETS INTO ONE TIME SERIES
combined = [TOPEX; JASON1; JASON2];




% LINE OF BEST FIT (fit first order polynomial)
a = polyfit(combined(:,1),combined(:,2),1); %linear fit 

yfit = polyval(a,combined(:,1));     	    %calculate y-values

plot(combined(:,1),yfit,'k-','LineWidth',2);% plot values on thick 
                                            % black solid line
                                            
          
                                            
                                            
% ADDING A LEGEND (top left corner)
legend('TOPEX','Jason 1','Jason 2','best fit','Location','NorthWest')                                            
      


                                            
% ADDING TITLE AND AXIS LABELS
title(['Mean Sea Level Anomalies from the TOPEX and Jason Altimeter' ...
'Missions'])
xlabel('Time (year)')                    
ylabel('Mean Sea Level Anomalies (mm)')  




% THE FOLLOWING COMMAND WON'T BE ASSESED

% RATE IS DISPLAYED ON SCREEN
fprintf('%s %4.1f %s\n','Rate of sea level rise is', a(1), ... 
'mm/year')




% RATE IS WRITEN ON THE PLOT
strl = ['Rate =' sprintf('%4.1f',a(1)) ' mm/year']; 
text(2004,70,strl);




% sprintf is the same as FPRINTF except that it returns the data in a 
% MATLAB variable rather than writing to a file.


