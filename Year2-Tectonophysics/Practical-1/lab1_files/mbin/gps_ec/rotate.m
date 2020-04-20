function [Vxyz,Venu] = rotate(OM,COM,P);

% ROTATE	Computes velocity at selected point given a rotation vector
%
%		Input:
%                 - OM(Rx,Ry,Rz) = rotation vector, deg/my
%                 - COM = covariance matrix of rotation vector (3x3 matrix) 
%                 - P = site coordinates, XYZ cartesian frame, meters
%                   P can be a vector or a n x 3 matrix with n site positions
%
%		Output:
%		  - Vxyz = result matrix in Cartesian frame. One line per site,
%		    with following format:
%		    vx vy vz  cxx cxy cxz cyy cyz czz
%                    (m/yr)    (covariance m^2/yr^2)
%		  - Venu = result matrix in local frame. One line per site,
%		    with following format:
%		    ve vn sve svn cor
  %                       (mm/yr) (unitless)
%
%		Call: [Vxyz,Venu] = rotate(OM,COM,P)

% make sure OM is a column vector
OM = OM(:);

% convert OM and COM from deg/My to rad/yr
Re = 6378137.0;
con = (Re * pi/180) * 1e-6;
OM = OM .* con;
COM = COM .* (con^2);

% compute unit position vector
X = P(:,1); Y = P(:,2); Z = P(:,3);
R = sqrt(X.^2+Y.^2+Z.^2);
Xu = X./R; Yu = Y./R; Zu = Z./R;

% compute position in ellipsoidal coordinates
T = zeros(size(X,1),1);
E = xyz2wgs([T X Y Z]);
lon = E(:,2).*pi/180;
lat = E(:,3).*pi/180;
cl = cos(lat); sl = sin(lat);
cp = cos(lon); sp = sin(lon);

% build cross product transformation matrix A
A = [];
for i=1:length(Xu)
  A = [A;
          0   Zu(i) -Yu(i);
       -Zu(i)    0   Xu(i);
        Yu(i) -Xu(i)    0];
end

% save some memory for large calculations
A = sparse(A);
COM = sparse(COM);

% compute cross product
v = A * OM;

% propagate rotation vector covariance
CV = A * COM * A';

% for each site
Vxyz = [];
Venu = [];
n = 1;
for i=1:3:length(v)

  % extract velocities in cartesian frame
  vx = v(i); vy = v(i+1); vz = v(i+2);

  % extract corresponding covariance
  Cxyz = CV(i:i+2,i:i+2);

  % build rotation matrix from cartesian to local coordinates
  R = [ -sl(n)*cp(n)   -sl(n)*sp(n)    cl(n);
         -sp(n)            cp(n)           0;
        -cl(n)*cp(n)   -cl(n)*sp(n)   -sl(n)];

  % rotate velocities from cartesian to local frame, convert to mm/yr
  tmp = R * [vx vy vz]';
  tmp = tmp .* 1e3;
  vn = tmp(1); ve = tmp(2); vu = tmp(3);

  % rotate covariance from cartesian to local frame
  Cneu = R * Cxyz * R';

  % extract stdev, correlation, convert to mm/yr
  svn = sqrt(Cneu(1,1)) * 1e3;
  sve = sqrt(Cneu(2,2)) * 1e3;
  svu = sqrt(Cneu(3,3)) * 1e3;
  cor_ne = Cneu(1,2)/(Cneu(1,1)^0.5 * Cneu(2,2)^0.5);
  cor_nu = Cneu(1,3)/(Cneu(1,1)^0.5 * Cneu(3,3)^0.5);
  cor_eu = Cneu(2,3)/(Cneu(2,2)^0.5 * Cneu(3,3)^0.5); % correlation, unitless

  % increment result matrices
  Vxyz = [Vxyz; vx vy vz Cxyz(1,1) Cxyz(1,2) Cxyz(1,3) Cxyz(2,2) Cxyz(2,3) Cxyz(3,3)];
  Venu = [Venu; ve vn sve svn cor_ne];

  % increment site number
  n = n+1;
end

