function OM = eul2rot(E)

% ROT2EUL	Convert Euler parameters lon, lat, angular velocity
%		into rotation vector OM (x y z).
%		E = [lon lat ang];
%		Call: OM = eul2rot(E);
%		X, Y, Z in deg/My
%		lat lon in degres, ang in deg/My

lon = E(1) * pi / 180.0;
lat = E(2) * pi / 180.0;
ang = E(3);

x = ang * cos(lat) * cos(lon);
y = ang * cos(lat) * sin(lon);
z = ang * sin(lat);

OM = [x y z];
