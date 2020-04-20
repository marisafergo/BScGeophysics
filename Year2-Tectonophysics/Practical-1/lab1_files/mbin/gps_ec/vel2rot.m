function [OM,COM,E,EL,STAT,RES] = vel2rot(P,V,CV)

% VEL2ROT	Estimate rotation parameters from site velocities.
%
%		Input:
%		  - P = site positions (m) in Cartesian frame
%		  - V = site velocities (m/yr) in Cartesian frame
%		  - CV = velocity covariance in Cartesian frame, format is:
%                        Cxx Cxy Cxz Cyy Cyz Czz  (m/yr)^2
%		  [use xyz2neu to convert velocities from NE to cartesian]
%		Output:
%		  - OM = rotation vector (deg/Myr)
%		  - COM = associated covariance matrix (deg^2/Myr^2)
%		  - E = Euler parameters [lon,lat,ang] (deg/Myr)
%		  - EL = standard errors on Euler parameters:
%			smaj = semi-major axis
%			smin = semi-minor axis
%			az = direction of semi-major axis
%			sang = angular velocity
%		  - STAT = statistics:
%			chi2 = chi-square
%			chi2r = reduced chi-square
%			dof = degres of freedom
%		  - RES = residuals:
%		        Vx Vy Vz Cxx Cxy Cxz Cyy Cyz Czz
%
%		Call: [OM,COM,E,EL,STAT,RES] = vel2rot(Pxyz,Vxyz,CVxyz)

% read site positions and convert to unit vector
X = P(:,1); Y = P(:,2); Z = P(:,3);
R = sqrt(X.^2+Y.^2+Z.^2);
Xu = X./R; Yu = Y./R; Zu = Z./R;

% read velocities and covariance
VX = V(:,1); VY = V(:,2); VZ = V(:,3);
CVxx = CV(:,1); CVxy = CV(:,2); CVxz = CV(:,3);
                CVyy = CV(:,4); CVyz = CV(:,5);
                                CVzz = CV(:,6);

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
  C(3*i-2:3*i,3*i-2:3*i) = [CVxx(i) CVxy(i) CVxz(i);
                            CVxy(i) CVyy(i) CVyz(i);
                            CVxz(i) CVyz(i) CVzz(i)];
end

% test C for singularity
if (rcond(C) < 1e-3)
  disp(['WARNING: covariance matrix ill-conditioned in vel2rot']);
  disp(['         removing off-diagonal terms']);
  C = diag(diag(C),0);
end

% solve for OM -- result will differ according to solver...
OM = inv(A'*(inv(C))*A) * A' * inv(C) * L;
%OM = pinv(A)*L;
%OM = lscov(A,L,C);

% compute covariance of unknowns
% A! PROBLEM HERE -- C HAS ALWAYS POSITIVE DIAGONAL TERMS, BUT
% COM SOMETIMES HAS NEGATIVE DIAGONAL TERMS... DON'T KNOW WHY.
COM = inv(A'*(inv(C))*A);

% convert OM from m/y to deg/Myr
Re = 6378137.0;
con = (Re * pi/180) * 1e-6;
OM = OM ./ con;
COM = COM ./ (con^2);

% convert rotation vector into Euler pole and ang. velocity
[E,CE,EL] = rot2eul(OM,COM);

% compute residuals and associated variance
[Vxyz,Venu] = rotate(OM,COM,P);
VX_res = VX - Vxyz(:,1);
VY_res = VY - Vxyz(:,2);
VZ_res = VZ - Vxyz(:,3);
CV_res = CV + [Vxyz(:,4:9)];
RES = [VX_res VY_res VZ_res CV_res];

% compute stats
Vobs = [VX;VY;VZ];
Vmod = [Vxyz(:,1);Vxyz(:,2);Vxyz(:,3)];
Sigm = [sqrt(CVxx);sqrt(CVyy);sqrt(CVzz)];
chi2 = sum(((Vobs-Vmod).^2)./Sigm.^2);
dof = 3*n-3;
chi2r = chi2/dof;
STAT = [chi2 chi2r dof];

