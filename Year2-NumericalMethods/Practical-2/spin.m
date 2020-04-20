% Matlab script to plot spin state of iron in ferropericlase as 
% a function of P and T
% P = Pressure
% T = Temperature
% n = fraction of low-spin iron
% h = matrix used to store enthalpy difference 

% load data - h.dat contains enthalpy difference between the high and
% and low-spin states as a function of pressure.
fid=fopen('h.dat');
m = fscanf(fid, '%f %f',[2,inf]);
fclose(fid);

% reorientate data to match the file
m = m';

x = 1:150;
% fit data 
a = polyfit(m(:,1),m(:,2),3);
y = polyval(a,x);

P = 0:1:140;
T = 300:100:4000;
p = size(P);
t = size(T);

for i=1:1:t(2)
  for j=1:1:p(2)
    % use expression taken from Tsuchiya et al. XXXXXXX
    n(i,j)= 1 / (1+(15*exp((polyval(a,P(j)))/(0.000086173324*(6/32)*T(i)))));
  end
end

pcolor(P,T,n); 
shading interp; % do not interpolate pixels
colorbar % add colorbar
colorbar('YTicklabel',{'0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'})
xlabel('Pressure (GPa)');
ylabel('Temperature (K)');
title('Plot of the fraction of low-spin iron in FeMgO in the lower mantle')
