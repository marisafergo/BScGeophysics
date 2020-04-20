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

x = OM(1); y = OM(2); z = OM(3);

% convert rotation vector from xyz to nea
lat = atan2(z,sqrt(x^2+y^2));
lon = atan2(y,x);
ang = sqrt(x^2+y^2+z^2);
E = [lon*180/pi lat*180/pi ang];

% convert covariance matrix from xyz to nea
if (isempty(COM))
  CE = [];
  EL = [];
else
  % compute Jacobian A!! INCORRECT!!
  jcom = (x^2+y^2)^2 / (x^4+2*x^2*y^2+y^2+z^2);
  j11 = -2*x*z/(x^2+2*x*y+y^2); j11 = j11/jcom;
  j12 = -2*y*z/(x^2+2*x*y+y^2); j12 = j12/jcom;
  j13 = 1/(x^2+y^2);            j13 = j13/jcom;
  jcom = x^2 / (x^2+y^2);
  j21 = -y / x;  j21 = j21/jcom;
  j22 = 1 / x;   j22 = j22/jcom;
  j23 = 0;
  jcom = 1 / (2*sqrt(x^2+y^2+z^2));
  j31 = 2*x;  j31 = j31/jcom;
  j32 = 2*y;  j31 = j31/jcom;
  j33 = 2*z;  j31 = j31/jcom;

  J = [j11 j12 j13;
       j21 j22 j23;
       j31 j32 j33];

  % propagate covariance
  CE = J * COM * J';
  CE = CE .* (180/pi)^2;

  % compute error ellipse, 1 sigma (68% confidence)
  [smaj, smin, az] = errell(CE(1:2,1:2),0.68);

  % compute uncertainty on angular velocity
  sigmaz = sqrt(CE(3,3));

  % output
  EL = [smaj,smin,az,sigmaz];
end
