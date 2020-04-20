
% MATLAB script to plot earthquake locations on a worldmap


% ______________________________________________________________
%|                   Marisabel Gonzalez                         |
%|                       03/03/2017                             |
%|______________________________________________________________|


% ______________________________________________________________
%|                         NOMENCLATURE                          
%|______________________________________________________________


%this script does nhoco bonhonho

% OPEN FILES FOR READING
fid1 = fopen('coast.dat' ,'r');  
fid2 = fopen('earthquake.dat' ,'r');




% THIS COMMAND READS THE DATA FROM THE FILES INTO MATRICES

%fid1 data
format1 = '%f %f';
coast = fscanf(fid1, format1, [2 inf]);

%fid2 data
format2 = '%f %f %f';
earthquake = fscanf(fid2, format2, [3 inf]);




% CALCULATING THE TRANSPONSE (as fscanf rearranges rows into columns)
coast = coast';
earthquake = earthquake';




% CLOSING ALL OPEN FILES
fclose(fid1);
fclose(fid2);





% ______________________________________________________________
%|                    PLOTTING THE DATA                             
%|______________________________________________________________

% this command allows multiple plots
hold on

plot(coast(:,2), coast(:,1), 'k-');

M = earthquake(:,3);
for i = 1:length(M)
 if (M(i) >= 5.0 && M(i) < 6.0)
     plot(earthquake(i,2),earthquake(i,1), 'go','MarkerSize' ,4);
 elseif (M(i) >= 6.0 && M(i) < 7.0) 
     plot(earthquake(i,2),earthquake(i,1), 'co','MarkerSize' ,8);
 elseif (M(i) >= 7.0 && M(i) < 8.0)   
     plot(earthquake(i,2),earthquake(i,1), 'bo','MarkerSize' ,12); 
 elseif (M(i) >= 8.0 && M(i) < 9.0)
     plot(earthquake(i,2),earthquake(i,1), 'mo','MarkerSize' ,16); 
 end     
end 

  
   

% ADDING TITLE AND AXIS LABELS
title('Earthquakes Over Magnitude 5 in 2007')
xlabel('Longitude/deg')                    
ylabel('Latitude/deg') 










