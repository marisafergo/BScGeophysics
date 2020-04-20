function satrot = rot_satpos(t_time, sat)

% ROT_SATPOS   Rotates satellite ECEF coordinates to account
%              for Earth rotation during signal travel time.

% earth rotation rate, rad/s
Omegae_dot = 7.2921151467e-5;

omegatau = Omegae_dot*t_time;

satrot = [];

R = [  cos(omegatau) sin(omegatau) 0;
      -sin(omegatau) cos(omegatau) 0;
          0               0        1];

satrot = R * sat;

