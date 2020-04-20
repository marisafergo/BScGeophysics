function [A,DA,SA,E,SE,DOP] = solve_PR(apr_pos,S,P,td,gd,drel);

% SOLVE_PR	Computes a position from pseudorange data
%     Input:
%       apr_pos = vector of apriori site position (ECEF, m) and clock bias (nsec)
%       S = 4 x n matrix of satellite position (ECEF, m) and clock bias (sec)
%       P = vector of n pseudorange data (ECEF, m)
%       td = troposheric delay in meters
%       gd = ionospheric group delay in meters
%       drel = relaticistic correction in meters
%     Output
%       A = [Xa Ya Za Ta] adjusted position and time in m and nsecs
%       DA = [DXa DYa DZa DTa] adjustments in m and nsecs
%       SA = [SXa SYa SZa STa] formal errors (m)
%       E = [lat lon height] adjusted position, ellipsoidal coordinates (deg, deg, m)
%       SE = [lat lon height] formal errors, ellipsoidal coordinates (deg, deg, m)
%       DOP = [vdop hdop pdop tdop gdop] dilution of precision
%
%     Usage:
%       [A,DA,SA,E,SE,DOP] = solve_PR(apr_pos,S,P,td,gd);

% speed of light, m/s
c_light = 0.299792458e9;

% A priori site position and receiver clock offset
Xo = apr_pos(1);
Yo = apr_pos(2);
Zo = apr_pos(3);
To = apr_pos(4);

% convert satellite position (meters)
Sx = S(1,:)';
Sy = S(2,:)';
Sz = S(3,:)';

% satellite clock bias (seconds)
St = S(4,:)';

% correct pseudorange for satellite clock bias
P = P + c_light.*(St);

% correct pseudorange for atmospheric delays and relativistic effects
P = P - td - gd - drel;

% model observables
RHO = sqrt((Sx-Xo).^2+(Sy-Yo).^2+(Sz-Zo).^2);

% vector of obs minus calc
L = P - RHO;

% partial derivatives
DX = -(Sx-Xo)./RHO;
DY = -(Sy-Yo)./RHO;
DZ = -(Sz-Zo)./RHO;
DT = ones(length(P),1).*(-c_light*1e-9);

% design matrix
A = [ DX DY DZ DT ];

% build covariance matrix of the observations (not used)
V = eye(length(P));

% run inversion, 3 possible ways in MATLAB:
%X = inv(A'*A) * A' * L;
X = pinv(A) * L;
%[X, DX] = lscov(A,L,V);

% compute adjusted position
Xa = Xo + X(1);
Ya = Yo + X(2);
Za = Zo + X(3);
Ta = To + X(4);

% convert to ellipsoidal coordinates
Ra= xyz2wgs([Ta Xa Ya Za]);

% covariance of unknowns:
Cx = inv(A'*A);

% rotate to local topocentric frame:
phi=Ra(3);
lam=Ra(2);
alt=Ra(4);
R = [	-sin(phi)*cos(lam)	-sin(phi)*sin(lam)	cos(phi);
     	-sin(lam)		cos(lam)		0;
      cos(phi)*cos(lam)	cos(phi)*sin(lam)	sin(phi)];
Cl = R * Cx(1:3,1:3) * R';

% compute DOPs:
vdop = sqrt(Cl(3,3));
hdop = sqrt(Cl(1,1)+Cl(2,2));
pdop = sqrt(Cl(1,1)+Cl(2,2)+Cl(3,3));
tdop = sqrt(Cx(4,4));
gdop = sqrt(Cl(1,1)+Cl(2,2)+Cl(3,3)+Cx(4,4));

% output:
A = [Xa Ya Za Ta]; % adjusted position and time in m and nsecs
DA = [X(1) X(2) X(3) X(4)]; % adjustments in m and nsecs
SA = [sqrt(Cx(1,1)) sqrt(Cx(2,2)) sqrt(Cx(3,3)) sqrt(Cx(4,4))]; % formal errors
E = [phi lam alt]; % adjusted position, ellipsoidal coordinates
SE = [sqrt(Cl(1,1)) sqrt(Cl(2,2)) sqrt(Cl(3,3))]; % formal errors
DOP = [vdop hdop pdop tdop gdop];

