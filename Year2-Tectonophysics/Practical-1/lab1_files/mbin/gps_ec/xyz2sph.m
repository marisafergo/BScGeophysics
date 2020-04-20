function S = xyx2sph(X);

% XYZ2SPH      	converts cartesian coordinates (x,y,z) into
%		spherical coordinates (lat,lon,ele).
%
%               Call: R = xyz2sph(S)
%               S is a nx4 matrix with time, X, Y, Z
%		A! first column of S is time but can be dummy.
%               R is a nx4 matrix with time, lon (lam), lat (phi), ele
%		                             (lon,lat in degrees!)

t = X(:,1);
x = X(:,2);
y = X(:,3);
z = X(:,4);

lat = atan2(z , (sqrt(x.^2+y.^2)));
lat = lat .* (180/pi);
lon = atan2(y , x);
lon = lon .* (180/pi);
ele = sqrt(x.^2+y.^2+z.^2);

S = [t lon lat ele];
