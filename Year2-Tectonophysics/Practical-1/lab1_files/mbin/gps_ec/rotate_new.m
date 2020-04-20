function [VC,CVC,VL,CVL,GMT] = rotate(OM,P,COM)

% ROTATE	Computes velocity and associated covariance for point P(X,Y,Z)
%		located on a plate that moves according to rotation vector OM
%
%		Input:
%		    P = xyz coordinates in meters
%		   OM = rotation vector in deg/My
%		  COM = associated covariance matrix in deg/My**2
%		        (can be empty matrix)
%
%		Output:
%		IN CARTESIAN XYZ FRAME:
%		   VC = xyz velocity, m/yr
%		  CVC = associated covariance matrix, m/yr**2
%		IN LOCAL NEU FRAME:
%		   VL = xyz velocity, m/yr
%		  CVL = associated covariance matrix, m/yr**2
%		GMT: lon, lat, ve, vn, se, sn, corr
%
%		Call: [VC,CVC,VL,CVL,GMT] = rotate_new(OM,P,COM);
%		   or [VC,CVC,VL,CVL,GMT] = rotate_new(OM,P,'');

if (isempty(COM))
  COM = zeros(3,3);
end

% convert OM and COM from deg/My to m/y
OM = OM .* 0.11119493;
COM = COM .* (0.11119493)^2;

% compute unit vector
X = P(:,1); Y = P(:,2); Z = P(:,3);
R = sqrt(X.^2+Y.^2+Z.^2);
P = [X./R Y./R Z./R];

% calculate xyz velocity at P (m/y)
VC = cross(OM,P);

% calculate associated covariance (m/y**2)
x = P(1); y = P(2); z = P(3);
jac = [0  z -y ;
      -z  0  x ;
       y -x  0];
jac
COM
jac*COM
CVC = jac * COM * jac';

% compute lat lon of P
lat = atan2(Z,sqrt(X^2+Y^2));
lon = atan2(Y,X);

% compute sines and cosines and build rotation matrix
cp = cos(lon); sp = sin(lon);
cl = cos(lat); sl = sin(lat);
Rot = [-sl*cp   -sl*sp    cl;
       -sp      cp        0;
       -cl*cp   -cl*sp   -sl];

% rotate VC to neu (m/y)
VL = Rot * VC';

% convert covariance matrix from xyz to neu by similarity
CVL = Rot * CVC * Rot';

% for GMT/psvelo
GMT = [lon*180/pi lat*180/pi VL(2)*1000 VL(1)*1000 sqrt(CVL(2,2))*1000 sqrt(CVL(1,1))*1000 CVL(1,2)*1000];
