% ______________________________________________________________
%|                   Marisabel Gonzalez                         |
%|                       02/10/2017                             |
%|______________________________________________________________|
% 

% THIS SCRIPT PLOTS THE SPIN STATE OF IRON IN FERROPERICLASE AS A FUNCTION 
% OF P AND T

% ______________________________________________________________
%|                         NOMENCLATURE                          
%|______________________________________________________________

% kb =  8.6173303e−5 eV⋅K−1
% a function of P and T
% P = Pressure
% T = Temperature
% n = fraction of low-spin iron
% h = matrix used to store enthalpy difference 
% ______________________________________________________________



%STEP 1
% opening file
fid = fopen('h.dat', 'r');

% reading the file
format = '%f %f';
m = fscanf(fid,format, [2 inf]);

% closing file
fclose(fid);

% calculating the transpose (only in fscanf)
m = m';



%STEP 2

hold on

plot(m(:,1),m(:,2));

x = 1:150;
a = polyfit(m(:,1),m(:,2),3);
yfit = polyval(a,x);


% STEP 3 and 4
P = 0:1:140;
T = 300:100:4000;
p = size(P);
t = size(T);

% STEP 5
m = 3;
S = 2;
Xfe = 0.1875;
Kb = 0.00008617332;




for i=1:1:t(2)
  for j=1:1:p(2)
    % use expression taken from Tsuchiya et al. XXXXXXX
    n(i,j)= 1/(1+m*(2*S+1)*exp((polyval(a,P(j)))/(Kb*Xfe*T(i))));
  end
end





 % STEP 6
%  % ADDING TITLE AND AXIS LABELS
pcolor(P,T,n); 
shading interp; % do not interpolate pixels
colorbar % add colorbar
colorbar('YTicklabel',{'0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'})
xlabel('Pressure (GPa)');
ylabel('Temperature (K)');
title('Plot of the fraction of low-spin iron in FeMgO in the lower mantle')




% ______________________________________________________________
%|                              END                    
%|______________________________________________________________



