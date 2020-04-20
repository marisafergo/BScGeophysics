function [x,y] = proj_velo(Dlon,Dlat,d);

D = sqrt(Dlon.^2 + Dlat.^2);
a = atan2(Dlat,Dlon) - d;
x = D .* cos(a);
y = D .* sin(a);

