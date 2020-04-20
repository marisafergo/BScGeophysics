function [E,CE,EL] = rot2eul(OM,COM);

% ROT2EUL	Convert rotation vector into Euler parameters.
%
%		Input:
%		- OM = rotation vector in deg/My
%		- COM = associated covariance matrix in (deg/My)^2
%		        [Cxx Cxy Cxz
%		         Cxy Cyy Cyz
%		         Cxz Cyz Czz]
%
%		Output:
%		- E = lon, lat, angular velocity (deg/Myr)
%		- CE = associated covariance matrix
%		- EL = [smaj,smin,az,sigmaz]
%		
%		COM can be [] (empty matrix) if no covariance info is
%		available. In that case, CE and EL will also be [].
%
%		Call: [E,CE,EL] = rot2eul(OM,COM);

% convert everything to radians
OM = OM .* (pi/180);
COM = COM .* (pi/180)^2;

x = OM(1); y = OM(2); z = OM(3);

% convert rotation vector from xyz to neu
ang = sqrt(x^2+y^2+z^2);
lat = atan2(z,sqrt(x^2+y^2));
%lat = (pi/2) - acos(z/ang);
lon = atan2(y,x);
E = [lon*180/pi lat*180/pi ang*180/pi];
%E = [lon*180/pi lat*180/pi ang];

% convert covariance matrix from xyz to nea
if (isempty(COM))
  CE = [];
  EL = [];
else
  % compute Jacobian
  % --> d(lat)/d(x,y,z)
  jcom = (x^2+y^2) / (x^2+y^2+z^2);
  j11 = -x*z / (x^2+y^2)^1.5;   j11 = j11*jcom;
  j12 = -y*z / (x^2+y^2)^1.5;   j12 = j12*jcom;
  j13 = 1 / (x^2+y^2)^0.5;      j13 = j13*jcom;
  % --> d(lon)/d(x,y,z)
  jcom = x^2 / (x^2+y^2);
  j21 = -y / x^2;  j21 = j21*jcom;
  j22 =  1 / x;    j22 = j22*jcom;
  j23 = 0;
  % --> d(ang)/d(x,y,z)
  jcom = 1 / (2*sqrt(x^2+y^2+z^2));
  j31 = 2*x;  j31 = j31*jcom;
  j32 = 2*y;  j31 = j31*jcom;
  j33 = 2*z;  j31 = j31*jcom;

  J = [j11 j12 j13;
       j21 j22 j23;
       j31 j32 j33];

  % propagate covariance
  CE = J * COM * J';

  % extract lat-lon part
  CLL = CE(1:2,1:2) .* (180/pi)^2;
  %CLL = CE(1:2,1:2);

  % compute error ellipse, 1 sigma => p=0.39346 (in 2D)
  [smaj, smin, az] = errell(CLL,0.39346);

  % compute uncertainty on angular velocity
  sigmaz = sqrt(CE(3,3));

  % output
  EL = [smaj,smin,az,sigmaz];
end
