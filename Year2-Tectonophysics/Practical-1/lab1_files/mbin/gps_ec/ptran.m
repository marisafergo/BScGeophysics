function [NE,CNE,ERR] = ptran(V,CV);

% PTRAN		Convert xyz velocity V and associated covariance CV
%		into neu velocity NEU, associated covariance CNEU and
%		error ellipse
%		V in m/yr
%		CV in m^2/yr^2
%		Call: [NE,CNE,ERR] = ptran(V,CV);
%		NE = vector with n and e components
%		CNE = associated covariance (2x2 martix)
%		ERR = error ellipse, 68% confidence

x = V(1); y = V(2); z = V(3);

% convert velocity vector from xyz to neu
n = atan2(z,sqrt(x^2+y^2));
e = atan2(y,x);
u = sqrt(x^2+y^2+z^2);

% convert covariance matrix from xyz to neu
% compute sines and cosines
cp = cos(e); sp = sin(e);
cl = cos(n); sl = sin(n);

% build the rotation matrix
R = [-sl*cp   -sl*sp    cl;
     -sp       cp        0;
     -cl*cp   -cl*sp   -sl];

% compute similarity
CNEU = R * CV * R';

% compute error ellipse, 1 sigma (68% confidence)
[smaj, smin, az] = errell(CNEU(1:2,1:2),0.68);

% convert semi-major axis orientation into degrees CW from north
az = (pi/2) - az;

% output
NE = [n*180/pi e*180/pi];
CNE = CNEU(1:2,1:2);
ERR = [smaj,smin,az*180/pi];

