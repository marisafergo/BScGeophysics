function [x,y,z] = sph2xyz(lon,lat,h);

% SPH2XYZ      	converts spherical coordinates into
%		cartesian coordinates.
%
%               Call: X = sph2xyz(lon,lat,h)
%		      lon,lat in degrees
%                     h not used
%               X in meters

R = 6378137;        % Earth's mean radius (meters)

lon = lon .* (pi/180);
lat = lat .* (pi/180);

x = R .* cos(lat) .* cos(lon);
y = R .* cos(lat) .* sin(lon);
z = R .* sin(lat);

