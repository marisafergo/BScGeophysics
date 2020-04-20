% MATLAB SCRIPT TO READ THE SEA LEVEL ANOMALIES
% MADE BY TOPEX AND JASON ALIMETER MISSIONS



                        
% MORE INFORMATION CAN BE FOUND IN THE FOLLOWING LINKS                                                           
% http://sealevel.colorado.edu/                              
% http://sealevel.colorado.edu/files/2014_rel1/sl_global.txt


% ______________________________________________________________
%|                   Marisabel Gonzalez                         |
%|                       08/03/2017                             |
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





% +-----------------------------------------------------------+
%                    PLOTTING THE TOPEX DATA
% +-----------------------------------------------------------+

subplot(1,3,1)
plot(TOPEX(:,1),TOPEX(:,2),'ro');         % plot values
title('TOPEX')                            % add title
xlabel('Time (year)')                     % add x-axis label
ylabel('Mean Sea Level Anomolies (mm)')   % add y-axis lable       
axis([1993 2003 -20 80])                  % set axes
hold on                                   % stop overwriting 
a = polyfit(TOPEX(:,1),TOPEX(:,2),1);     %linear fit 
yfit = polyval(a,TOPEX(:,1));             %calculate y-values
plot(TOPEX(:,1),yfit,'k-','LineWidth',2); % plot values
strl = ['Rate =' sprintf('%4.1f',a(1)) ' mm/year']; 
text(1994.5,70,strl);


% +-----------------------------------------------------------+
%                  PLOTTING THE JASON1 DATA
% +-----------------------------------------------------------+

subplot(1,3,2)
plot(JASON1(:,1),JASON1(:,2),'gs');        % plot values
title('Jason 1')                           % add title
xlabel('Time (year)')                      % add x-axis label
ylabel('Mean Sea Level Anomolies (mm)')    % add y-axis label                        
axis([2003 2008.55 -20 80])                % set axes
hold on                                    % stop overwriting 
a = polyfit(JASON1(:,1),JASON1(:,2),1);    %linear fit 
yfit = polyval(a,JASON1(:,1));             %calculate y-values
plot(JASON1(:,1),yfit,'k-','LineWidth',2); % plot values
strl = ['Rate =' sprintf('%4.1f',a(1)) ' mm/year']; 
text(2003.8,70,strl);



% +-----------------------------------------------------------+
%                  PLOTTING THE JASON2 DATA
% +-----------------------------------------------------------+


subplot(1,3,3)
plot(JASON2(:,1),JASON2(:,2),'y^');        % plot values
title('Jason 2')                           % add title
xlabel('Time (year)')                      % add x-axis label
ylabel('Mean Sea Level Anomolies (mm)')    % add y-axis label     
axis([2008.55 2014 -20 80])                % set axes
hold on                                    % stop overwriting
a = polyfit(JASON2(:,1),JASON2(:,2),1);    %linear fit 
yfit = polyval(a,JASON2(:,1));             %calculate y-values
plot(JASON2(:,1),yfit,'k-','LineWidth',2); % plot values
strl = ['Rate =' sprintf('%4.1f',a(1)) ' mm/year']; 
text(2009.2,70,strl);


