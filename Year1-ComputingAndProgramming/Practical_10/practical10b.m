% ______________________________________________________________
%|                   Marisabel Gonzalez                         |
%|                       03/03/2017                             |
%|______________________________________________________________|

% volc: matrix storing raw data 
% x:  vector containing x-values (distance from Kilauea (in km)
% yfit: y-values - fitting all the data (age in Myear)
% yfit_e: y-values - ignoring two youngest volcanoes (age in Myear)
% bf: quadratic coefficients - using all the data
% bf_e: quadratic coefficients - ignoring two youngest volcanoes 
% final = matrix to store output values for writing out
% v1 = speed of Pacific plate - fitting all the data
% v2 = speed of Pacific plate - ignoring two youngest volcanoes 



% OPEN FILE FOR READING
fid = fopen('volcanoes.dat' ,'r');  


% THIS COMMAND READS THE DATA FROM THE FILE INTO A MATRIX

%fid data
format = '%f %f';
volc = fscanf(fid, format, [2 inf]);

% CALCULATING THE TRANSPONSE (as fscanf rearranges rows into columns)
volc = volc';


% CLOSING FILE
fclose(fid);


% ______________________________________________________________
%|                    PLOTTING THE DATA                             
%|______________________________________________________________

% THIS COMMANDS ALLOWS MULTIPLE PLOTS
 hold on
 

% PLOTTING X-axis AND Y-axis
plot(volc(:,1),volc(:,2),'bo')


% ADDING TITLE AND AXIS LABELS
title('Plot of Volcano Age Versus Distance from Kilauea')
xlabel('Distance from Kilauea (km)')                    
ylabel('Age (Myear)')  


x = [0:100:3000]; 

  
% LINE OF BEST FIT (fit first order polynomial)
bf = polyfit(volc(:,1),volc(:,2),1);    %linear fit 

yfit = polyval(bf,x);     	    %calculate y-values

plot(x,yfit,'k-')               % plot values black solid line
      


% ______________________________________________________________
%|         ESTIMATIVE OF THE SPEED(v) OF THE PACIFIC PLATE                                        
%|______________________________________________________________

v1 = 1/bf(1);




% a nossa bf (best fit line, e a gradiente do grafico
% a gradiente e dy/dy, que e t/d nestr caso
% velocidade seria d/t, entao a velocidade seria o inverso de bf
% o nosso v ja e a velocidade media, visto que e a gradiente




% ______________________________________________________________
%|             EXCLUDING THE TWO YOUNGEST VOLCANOES                                     
%|______________________________________________________________

age = volc(:,2);
volc_l = length(age);



bf_e = polyfit(volc(3:17,1),volc(3:17,2),1);    %linear fit 

yfit_e = polyval(bf_e,x);     	    %calculate y-values

plot(x,yfit_e,'k-')               % plot values black solid line


v2 = 1./bf_e(1);




% criamos a variavel x para que a nossa seguda bf (bf_e) com os
% volcoes mais novos excluidos comecasse a partir de zero e nao de
% 3 como estabelecido em volc(3:17,1)
% usamos um intervalo de 500 just because, de 100 tambem iria resultar 
% ou um qualquer outro valor



% ______________________________________________________________
%|                      STORING THE DATA                    
%|______________________________________________________________


fit = fopen('fit.dat', 'w');  % creating file to store data



% CREATING MATRIX CONTAINING OUTPUT

value1 = volc(:,1);  %distance 
value2 = volc(:,2);  % age - 
value3 = polyval(yfit,volc(:,1));    % age - using all data points
value4 = polyval(yfit_e,volc(:,1));  % age - ignoring two youngest volcanoes


final = [value1 value2 value3 value4];

final = final';  % calculating transpose 

% tambem poderia ter sido feito assim para poupar lineas
% final =[volc(:,1) volc(:,2) polyval(yfit,volc(:,1))polyval(yfit_e,volc(:,1))];



% WRITING HEADERS
format1 = '%20s %20s %20s %20s';
fprintf(fit, format1, 'Distance (km)','Age volc (Myr)', ...
'Age bf (Myr)', 'Age bf_e (Myr)'); 

% WRITING DATA INTO FILE
format2 = '%15i %15.1f %15.1f %15.1f';
fprintf(fit, format2, final);



%CLOSING FILE
fclose(fit);


% ______________________________________________________________
%|                              END                    
%|______________________________________________________________



