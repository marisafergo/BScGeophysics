function [gd] = klobuchar(X,S,t_gps,alpha,beta)

% KLOBUCHAR  Computes the ionospheric group delay from broadcast parameters
%            using Klobuchar's (1975, 1996) algorithm. Vectorized.
%
%            Input:
%              X = coordinates of GPS site, ECEF (m)
%              S = satellite coordinates, ECEF (m), nx3 matrix
%              t_gps = time of GPS observation in seconds of the day, n-component vector
%              alpha = alpha parameters from broadcast ephemerides (4x1 vector)
%              beta = beta parameters from broadcast ephemerides (4x1 vector)
%
%            Output:
%              gd = ionospheric group delay, nx2 matrix,
%                   L1 first column, L2 second column
%
%            Usage:
%              [gd] = klobuchar(X,S,t_gps,alpha,beta)
%
% ecalais@purdue.edu, Wed Nov  4 15:33:45 EST 2009

% debug
%X = 1.0e+06 .* [4.4335 0.3627 4.5562];
%[eph,alpha,beta] = read_rinexn('epgga2.010');
%S=[];
%t_gps = [];
%for t=0:30:24*3600
%satpos = get_satpos(t+4*24*3600,31,eph,0);
%S = [S satpos];
%t_gps = [t_gps t];
%end
%S = S';
%t_gps = t_gps';

% speed of light, m/s
c = 0.299792458e9;

% L1 and L2 frequencies, Hz
f1 = 1.57542e9;
f2 = 1.2276e9;

% compute GPS ellipsoidal coordinates in radians
R = xyz2wgs([0 X(1) X(2) X(3)]);
lam_gps = R(2) * pi / 180;
phi_gps = R(3) * pi / 180;

% compute sat elevation and azimuth (in radians)
[az,el,le] = azelle(S,X);

% convert to units of "semicircles": 1 SC = 180 degrees
phi_gps_sc = phi_gps / pi;
lam_gps_sc = phi_gps / pi;
az_sc = az ./ pi;
el_sc = el ./ pi;

% compute Earth angle
psi = (0.0137) ./ (el_sc + 0.11) - 0.022;

% compute sub-ionospheric latitude
phi_sip = phi_gps_sc + psi .* cos(az);
I = find(abs(phi_sip) > 0.416);
phi_sip(I) = 0.416 .* phi_sip(I) ./ abs(phi_sip(I));

% compute sub-ionospheric longitude
lam_sip = lam_gps_sc + psi .* sin(az) ./ cos(phi_sip);

% compute geomagnetic latitude
phi_mag = phi_sip + 0.064 .* cos(lam_sip-1.167);

% compute local time at sub-ionospheric point
t_loc = lam_sip * 43200 + t_gps;
I = find(t_loc >= 86400);
t_loc(I) = t_loc(I) - 86400;
I = find(t_loc < 0);
t_loc(I) = t_loc(I) + 86400;

% compute slant factor of mapping function
SF = 1 + 16 .* (0.53 - el_sc).^3;

% compute period
P = beta(1).*phi_mag + beta(2).*phi_mag.^2 + beta(3).*phi_mag.^3 + beta(4).*phi_mag.^4;
I = find(P < 72000);
P(I) = 72000;

% compute amplitude
Q = alpha(1).*phi_mag + alpha(2).*phi_mag.^2 + alpha(3).*phi_mag.^3 + alpha(4).*phi_mag.^4;
I = find(Q < 0);
Q(I) = 0;

% compute phase
x = 2*pi.*(t_loc - 50400) ./ P;

% final result for L1
I = find(abs(x) > 1.57);
gd1(I) = c .* SF(I) .* 5e-9;
I = find(abs(x) <= 1.57);
gd1(I) = c .* SF(I) .* (5e-9 + Q(I) .* (1 - x(I).^2./2 +x(I).^4./2));

% for L2
gd2 = (f1^2/f2^2) .* gd1;

% output
gd = [gd1 ; gd2];
gd = gd';

