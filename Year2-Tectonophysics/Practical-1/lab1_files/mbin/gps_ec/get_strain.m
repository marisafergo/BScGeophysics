function M = get_strain(lon,lat,ve,vn,V,opt);

% GET_STRAIN    Computes strain rates from velocities (horizontal)
%               Input:
%                 lon, lat = coordinates of polygon vertices in degrees
%                 ve, vn = velocities at vertices in m/yr
%                 V = velocity covariance information for this polygon:
%                 --> n x 3 matrix => assume [sve svn corr], sve,sve in m/yr
%                 --> other matrix => assume (m/yr)^2 and:
%                     [ 11 12                 site 1 (will be reference)
%                       21 22
%                             11 12           site 2
%                             21 22 
%                                   ...etc ]  etc...
%		  opt = 1 or 0 to display output or not
%
% WARNING -- INPUT UNITS MUST BE METERS
%
%		Output:
%                 M = [lono lato e1 e2 azim dire omega epsxx epsxy epsyy snd ssnd];
%                       e1, e2 = principal strains, 10^-9 /year
%                       azim = azimuth of e1 (CCW from N), degrees
%                       dire = directin of e1 (CCW from E), degrees
%                       omega = rotation rate, degree/Myr
%                       epsxx, epsxy, epsyy = strain rate tensor, 10^-9/yr
%                       se1, se2 = std.dev. of e1, e2, 10^-9/yr
%                       snd, ssnd = second invariant + std. dev., 10^-9/yr
%
%               Call: M = get_strain(lon,lat,ve,vn,V,opt);
%
%     To get a whole network from psvelo file:
%         [lon,lat,ve,vn,sve,svn,cne,site,v]=textread('file','%f %f %f %f %f %f %f %s %f');
%         ve = ve .* 1e-3; vn = vn .* 1e-3;
%         scale = 2;
%         sve = sve .* 1e-3 * scale; svn = svn .* 1e-3 * scale;

% number of sites
num_nodes = length(lon);

% convert lat lon from degrees to meters w.r.t. reference point
[x,y,z] = wgs2xyz(lon,lat,zeros(num_nodes,1));
dx=x-x(1); dy=y-y(1); dz=z-z(1);
[NEU,CNEU,E] = xyz2neu([x(1) y(1) z(1)],[dx dy dz], ...
               zeros(num_nodes,3),zeros(num_nodes,3));
x = NEU(:,2);
y = NEU(:,1);

% compute velocity w.r.t. reference point
vx = (ve - ve(1));
vy = (vn - vn(1));

% figure out covariance
if (size(V,2) == 3)
  sve = V(:,1);
  svn = V(:,2);
  cor = V(:,3);
  V = zeros(num_nodes*2,num_nodes*2);
  for i=1:num_nodes
    V(2*i-1:2*i,2*i-1:2*i) = [sve(i)^2 cor(i);
                              cor(i) svn(i)^2];
  end
end

% setup design matrix, observation vector, and covariance matrix
A = [];
L = [];
C = zeros(2*(num_nodes-1),2*(num_nodes-1));

% propagation matrix for vector difference
D = [1 0 -1  0  ;
     0 1  0 -1 ];

% start at 2 because first equations are empty
for i=2:num_nodes
  % fill up design matrix
  A = [ A;
        x(i) y(i) 0    0 ;
          0    0  x(i) y(i)];
  % fill up data vector = velocities w.r.t reference point
  L = [ L;
       vx(i);
       vy(i)];
  % form covariance matrix for this point + reference point
  k = 2*i-1;
  C_ini = [ V(k,k)      0         0         0      ;
              0      V(k+1,k+1)   0         0      ;
              0         0       V(1,1)      0      ;
              0         0         0      V(2,2)   ];
  %C_ini = [ V(k,k)   V(k,k+1)   V(k,1)   V(k,2)    ;
  %          V(k+1,k) V(k+1,k+1) V(k+1,1) V(k+1,2)  ;
  %          V(1,k)   V(1,k+1)   V(1,1)   V(1,2)    ;
  %          V(2,k)   V(2,k+1)   V(2,1)   V(2,2)   ];
  % compute covariance matrix of velocities w.r.t reference point
  C_tmp = D * C_ini * D';
  % fill up covariance matrix
  C(2*i-3:2*i-2,2*i-3:2*i-2) = C_tmp;
end

% weight matrix
W = inv(C);

% solve for velocity gradient tensor
c = cond(A'*A);
%S = pinv(A) * L;
%[S,STDS,MSE,CS] = lscov(A,L,C);
S = inv(A'*W*A) * A'*W * L;

% compute covariance of unknowns
CS = inv(A'*W*A);

%%%%% NOT USED YET
% compute forward model and form residuals
%Lhat = A * S;
%Res = (L - Lhat);
% compute X-statistics (=VtPV)
%Xstat = Res' * inv(CS) * Res;
% degrees of freedom
%dof = 2*num_nodes - 4;
% compute X-probability
%xp = chi2_cdf(Xstat,dof);
%%%%% NOT USED YET

% velocity gradient tensor: extract results
exx = S(1); exy = S(2); eyx= S(3); eyy = S(4);
sexx = sqrt(CS(1,1)); sexy = sqrt(CS(2,2));
seyx = sqrt(CS(3,3)); seyy = sqrt(CS(4,4));

% propagation matrix from velocity gradient to strain
% from: EPS = 0.5 * (E + E') and W = 0.5 * (E - E')
B = [0 0  1  0   0  0 ; % epsxx
     0 0  0 .5  .5  0 ; % epsxy
     0 0  0  0   0  1 ; % epsyy
     0 0  0 .5 -.5  0 ; % omega
     0 0  1  0   0 -1 ; % gamma1
     0 0  0  1   1  0]; % gamma2

% calculate strain components
EPS = B * [0 0 exx exy eyx eyy]';

% extract strain components
epsxx = EPS(1);
epsxy = EPS(2);
epsyy = EPS(3);
omega = EPS(4);
gamma1 = EPS(5);
gamma2 = EPS(6);

% propagate covariance of velocity gradient CS to covariance of strain
% pad CS with zeros first
CC = zeros(6,6);
CC(3:6,3:6) = CS;
CEPS = B * CC * B';

% extract variance of strain components
sepsxx = sqrt(CEPS(1,1));
sepsxy = sqrt(CEPS(2,2));
sepsyy = sqrt(CEPS(3,3));
somega = sqrt(CEPS(4,4));
sgamma1 = sqrt(CEPS(5,5));
sgamma2 = sqrt(CEPS(6,6));

% compute principal strain axes
e1 = 0.5*(epsxx+epsyy) + sqrt((epsxx-epsyy)^2/4+epsxy^2);
e2 = 0.5*(epsxx+epsyy) - sqrt((epsxx-epsyy)^2/4+epsxy^2);
azim = -0.5*atan2(2*epsxy,(epsxx-epsyy));
dire = 0.5*atan2(2*epsxy,(epsxx-epsyy));
% comput maximum shear strain
gamma = sqrt((epsxx-epsyy)^2 + (2*epsxy)^2);

% Jacobian = partials of e1,e2 w.r.t. epsxx,epsyy,epsxy
% ADD partials of AZIM TO GET SAZIM
df = 1 / (2 * sqrt((epsxx-epsyy)^2/4+epsxy^2));
j11 = 0.5 + (df * ((epsxx-epsyy)/2));
j12 = 0.5 + (df * ((epsyy-epsxx)/2));
j13 =        df * epsxy^2;
j21 = 0.5 - (df * ((epsxx-epsyy)/2));
j22 = 0.5 - (df * ((epsyy-epsxx)/2));
j23 =     -  df * epsxy^2;
J = [ j11 j12 j13  ;
      j21 j22 j23  ;
      0   0   0   ];

% use Jacobian to propagate sexx, seyy, sexy into se1, se2
CP = J * CEPS(1) * J';
se1 = sqrt(CP(1,1));
se2 = sqrt(CP(2,2));
sazim = 0; % for now

% compute second invariant
snd = (1/sqrt(2)) * sqrt(abs(epsxy^2 + epsxx*epsyy));

% Jacobian
df = 1 / (2*sqrt(2)*sqrt(abs(epsxy^2 + epsxx*epsyy)));
j11 = df * epsyy;
j12 = df * epsxx;
j12 = df * epsxy^2;
J = [ j11 j12 j13  ;
      0   0   0    ;
      0   0   0   ];

% use Jacobian to propagate sepsxx, sepsyy, sepsxy into ssnd
Csnd = J * CEPS(1:3,1:3) * J';
ssnd = sqrt(Csnd(1,1));

% compute "location" of strain tensor
lono = mean(lon);
lato = mean(lat);

% convert units to ppb/yr and deg/My
azim = azim * 180/pi;
dire = dire * 180/pi;
exx = exx*1e9; exy = exy*1e9; eyx = eyx*1e9; eyy = eyy*1e9;
sexx = sexx*1e9; sexy = sexy*1e9; seyx = seyx*1e9; seyy = seyy*1e9;
epsxx = epsxx*1e9; epsxy = epsxy*1e9; epsyy = epsyy*1e9;
sepsxx = sepsxx*1e9; sepsxy = sepsxy*1e9; sepsyy = sepsyy*1e9;
e1 = e1*1e9; e2 = e2*1e9;
se1 = se1*1e9; se2 = se2*1e9;
snd = snd*1e9; ssnd = ssnd*1e9;
gamma1 = gamma1*1e9; sgamma1 = sgamma1*1e9;
gamma2 = gamma2*1e9; sgamma2 = sgamma2*1e9;
gamma = gamma*1e9;
omega = omega * 1e6; somega = somega * 1e6;

% result
M = [lono lato e1 e2 azim dire omega epsxx epsxy epsyy snd ssnd];

% display result
if (opt == 1)
display(['------------------------------------']);
display(['Results (ppb/yr), extension positive']);
display(['------------------------------------']);
display(['Velocity gradient:']);
display(['  exx = ' num2str(exx,'%.2f') ' +- ' num2str(sexx,'%.2f') ' ppb/yr']);
display(['  exy = ' num2str(exy,'%.2f') ' +- ' num2str(sexy,'%.2f') ' ppb/yr']);
display(['  exy = ' num2str(eyx,'%.2f') ' +- ' num2str(seyx,'%.2f') ' ppb/yr']);
display(['  eyy = ' num2str(eyy,'%.2f') ' +- ' num2str(seyy,'%.2f') ' ppb/yr']);
display(['Strain rate tensor:']);
display(['  epsxx = ' num2str(epsxx,'%.2f') ' +- ' num2str(sepsxx,'%.2f') ' ppb/yr']);
display(['  epsxy = ' num2str(epsxy,'%.2f') ' +- ' num2str(sepsxy,'%.2f') ' ppb/yr']);
display(['  epsyy = ' num2str(epsyy,'%.2f') ' +- ' num2str(sepsyy,'%.2f') ' ppb/yr']);
display(['Second invariant:']);
display(['  snd = ' num2str(snd,'%.2f') ' +- ' num2str(ssnd,'%.2f') ' ppb/yr']);
display(['Principal strains:']);
display(['  eps1 = ' num2str(e1,'%.2f') ' +- ' num2str(se1,'%.2f') ' ppb/yr (most extensional)']);
display(['  eps2 = ' num2str(e2,'%.2f') ' +- ' num2str(se2,'%.2f') ' ppb/yr (most compressional)']);
display(['  azimuth = ' num2str(azim,'%.2f') ' +- ' num2str(sazim,'%.2f') ' (eps1, CW from north)']);
display(['Rotation:']);
display(['  omega = ' num2str(omega,'%.2f') ' +- ' num2str(somega,'%.2f') ' deg/My']);
display(['Maximum shear:']);
display(['  gamma1 = ' num2str(gamma1,'%.2f') ' +- ' num2str(sgamma1,'%.2f') ' ppb/yr']);
display(['  gamma2 = ' num2str(gamma2,'%.2f') ' +- ' num2str(sgamma2,'%.2f') ' ppb/yr']);
display(['  gamma = ' num2str(gamma,'%.2f') ' ppb/yr']);
end
