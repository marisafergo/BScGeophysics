function XYZ = neu2xyz(O,V)

% XYZ2NEU	Convert local topocentric into ECEF
%		Call: XYZ = neu2xyz(O,V)
%		O = origin vector in ellipsoidal coordinates, or n x 3 matrix
%		V = position or velocity vector in NEU frame (m or m/yr), or n x 3 matrix

% initialize variables
lat = O(:,1); lon = O(:,2); height = O(:,3);
vn = V(:,1); ve = V(:,2); vu = V(:,3);
XYZ = [];

% convert position(s) of origin to ECEF
[XR,YR,ZR] = wgs2xyz(lon,lat,height);
T = zeros(size(XR,1),1);

% convert origin vector to ellipsoidal coordinates then to in radians
%E = xyz2wgs([T XR YR ZR]);
lon = lon.*pi/180; % longitude
lat = lat.*pi/180; % latitude

% compute sines and cosines
cp = cos(lon); sp = sin(lon); % longitude = phi
cl = cos(lat); sl = sin(lat); % latitude = lam

for i=1:size(V,1)
  % build the rotation matrix
  R = [ -sl(i)*cp(i)   -sl(i)*sp(i)    cl(i);
         -sp(i)            cp(i)           0;
         cl(i)*cp(i)    cl(i)*sp(i)    sl(i)];

  % apply the rotation
  XYZi = R' * [vn(i);ve(i);vu(i)];

  % increment result matrix NEU
  XYZ = [XYZ;XYZi'];
end

