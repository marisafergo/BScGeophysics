function [OM,COM,E,chi2,dof,smaj,smin,az,sang] = vel2rot(Pxyz,Vxyz,CVxyz)

% VEL2ROT	Estimate rotation parameters from site velocities.
%
%		Input:
%		  - Pxyz = site positions (m) in Cartesian frame
%		  - Vxyz = site velocities (m/yr) in Cartesian frame
%		  - CVxyz = velocity covariance in Cartesian frame, format is:
%                        Cxx Cxy Cxz Cyy Cyz Czz
%		Output:
%		  - OM = rotation vector (deg/Myr)
%		  - COM = associated covariance matrix (deg^2/Myr^2)
%		  - E = Euler parameters [lon,lat,ang] (deg/Myr}
%		  - Statistics:
%			chi2 = chi-square
%			dof = degres of freedom
%		  - Standard errors on Euler parameters:
%			smaj = semi-major axis
%			smin = semi-minor axis
%			az = direction of semi-major axis
%			sang = angular velocity
%
%		Call: [OM,COM,E,chi2,dof,smaj,smin,az,sang] = vel2rot(V,P)
%
% WARNING!!! OM and E OK, stats and std dev. NOT OK!!!

% read site positions and convert to unit vector
X = Pxyz(:,1); Y = Pxyz(:,2); Z = Pxyz(:,3);
R = sqrt(X.^2+Y.^2+Z.^2);
Xu = X./R; Yu = Y./R; Zu = Z./R;

% read velocities
VX = V(:,1); VY = V(:,2); VZ = V(:,3);

% number of data points
n = length(Xu);

% built observation vector, design matrix, and covariance
L = [];
A = [];
C = zeros(3*n,3*n);
for i=1:n
  % observation vector
  L = [L;VX(i);VY(i);VZ(i)];

  % design matrix
  A = [A;
       0      Zu(i)  -Yu(i);
      -Zu(i)     0    Xu(i);
       Yu(i)  -Xu(i)     0];

  % covariance matrix
  C(3*i-2:3*i,3*i-2:3*i) = [CVxx CVxy CVxz;
                            CVxy CVyy CVyz;
                            CVxz CVyz CVzz];
end

% invert 3D velocities for OM
OM = pinv(A) * L;

% compute covariance of unknowns OM
COM = inv(A'*(inv(C)*A);

% convert OM from m/y to deg/Myr
OM = OM ./ 0.11119493;
COM = COM ./ (0.11119493^2);

% convert rotation vector into Euler pole and ang. velocity
E = rot2eul(OM);

% compute residuals
PRED = rotate(OM,P);
VX_res = VX - PRED(:,1);
VY_res = VY - PRED(:,2);
VZ_res = VZ - PRED(:,3);

% compute chi2 (= sigma0)
Vobs = [VX;VY;VZ];
Vmod = [PRED(:,1);PRED(:,2);PRED(:,3)];
Sigm = [SVX;SVY;SVZ];
chi2 = sum(((Vobs-Vmod).^2)./Sigm.^2);
 
% degrees of freedom
dof = 3*n - 3;

% compute reduced chi2 (= a posteriori variance factor)
red_chi2 = chi2 / dof;

% scale variance by chi2
COM = COM .* red_chi2;

% rotate covariance in local topocentric frame
phi=E(2); % latitude
lam=E(1); % longitude
R = [-sin(phi)*cos(lam)  -sin(phi)*sin(lam)  cos(phi);
     -sin(lam)            cos(lam)             0;
     -cos(phi)*cos(lam)  -cos(phi)*sin(lam) -sin(phi)];
COM = COM .* (pi/180)^2; % convert from deg^2/My^2 to rad^2/My^2
Cl = R * COM * R';       % compute similarity

% extract 2x2 matrix with n and e components and remove velocity scale
vscale = (OM(1)*pi/180)^2 + (OM(2)*pi/180)^2 + (OM(3)*pi/180)^2;
Cl_ne = Cl(1:2,1:2) ./ vscale;

% compute error ellipse, 1 sigma (68% confidence)
[smaj, smin, az] = errell(Cl,0.68);

% convert semi-major axis orientation into degrees CW from north
az = (pi/2)-az);

% compute uncertainty on angular velocity
sang = sqrt(Cl(3,3)) * 1e6;

smaj = smaj * 180/pi;
smin = smin * 180/pi;
az = az * 180/pi;
sang = sang * 180/pi;
