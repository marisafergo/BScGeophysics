function E = rot2eul(OM)

% ROT2EUL	Convert rotation vector OM (x y z) into
%		Euler parameters lon, lat, angular velocity.
%		E = [lon lat ang];
%		Call: E = rot2eul(OM);
%		X, Y, Z in deg/My
%		lat lon in degres, ang in deg/My

x = OM(1); y = OM(2); z = OM(3);

lat = atan2(z,sqrt(x^2+y^2));
lon = atan2(y,x);
ang = sqrt(x^2+y^2+z^2);

lat = lat * 180.0 / pi;
lon = lon * 180.0 / pi;

E = [lon lat ang];
