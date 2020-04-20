% TEST_RIGID	Find the "most rigid" subset of sites from a psvelo velocity
%		file (= most consistent with rigid rotation), then tests how
%		the other sites fit that best subset.
%
%		Input:
%		  in_file = input velocity file in psvelo format (mm/yr)
%		  sig_max = minimum velocity uncertainty (mm/yr)
%		  N = number of sites to consider
%		  best = rank of subset to call "best"
%		Output
%
%		Note: uses matlab routines from ~/Matlab/stats/
%

%addpath ~/Matlab/gps_ec/
%addpath ~/Matlab/stats/
%in_file = 'velo_c.dat';
in_file = 'junk.dat';
sig_max = 2;	% sigma threshold
N = 11;		% number of sites
best = 1;	% # in list of best subsets

% test site
lon_test = 40.19;
lat_test = -3.00;
ve_test = 25.12;
vn_test = 13.84;
se_test = 0.11;
sn_test = 0.15;
[x,y,z] = wgs2xyz(lon_test,lat_test,0);
Pxyz_test = [x y z];

% read data
disp(['-------------------------'])
disp(['Reading ' in_file]);
[lon,lat,ve,vn,sve,svn,cne,site]=textread(in_file,'%f %f %f %f %f %f %f %s');
h=zeros(length(lon),1);
vu=zeros(length(lat),1);
svu=zeros(length(lat),1);
cnu=zeros(size(cne));
ceu=zeros(size(cne));
nsites = length(lat);
disp(['Found ' num2str(nsites) ' sites']);

% select sites
I = find(sqrt(sve.^2+svn.^2) < sig_max);
lon = lon(I); lat = lat(I); h = h(I);
ve = ve(I); vn = vn(I); vu = vu(I);
sve = sve(I); svn = svn(I); svu = svu(I);
cne = cne(I); cnu = cnu(I); ceu = ceu(I);
site = site(I,:);
nsites = length(lat);
disp(['Selected ' num2str(nsites) ' sites with uncertainty less than ' ...
     num2str(sig_max) ' mm/yr']);

% convert site positions and velocities to cartesian
disp(['Converting positions and velocities to cartesian']);
[x,y,z] = wgs2xyz(lon,lat,h);
Pxyz = [x y z];
O = [lat lon h];
% make sure velocities are converted to m/yr
Vneu = [vn ve vu] .* 1000.0;
SVneu = [svn sve svu] .* 1000.0;
CVneu = [cne cnu ceu] .* (1000.0^2);
[Vxyz,CVxyz] = neu2xyz(O,Vneu,SVneu,CVneu);

% make a list of combination of N sites
ncomb = factorial(nsites) / (factorial(N) * factorial(nsites-N));
L = comb_nk([1:nsites],N);
disp(['Found ' num2str(ncomb) ' combinations of ' num2str(N) ...
      ' sites (' num2str(size(L,1)) ')']);
%if (size(L,1)~=ncomb) error('Problem with the number of combinations'); end;

% for each combination of sites
disp(['Testing each combination...']);
OUT = [];
SITES = [];
for i=1:length(L)
  % extract the sites
  si = L(i,:);
  sn = site(si,:);
  p = Pxyz(si,:);
  v = Vxyz(si,:);
  cv = CVxyz(si,:);
  % compute angular rotation and statistics
  [OM,COM,E,EL,STAT] = vel2rot(p,v,cv);
% compute predicted velocity at test location
[Vxyz_test,Venu_test] = rotate(OM,COM,Pxyz_test);
dV = sqrt((Venu_test(1)-ve_test)^2 + (Venu_test(2)-vn_test)^2);
dS = sqrt((Venu_test(3)-se_test)^2 + (Venu_test(4)-sn_test)^2);
  % list of sites
  SITES = [SITES; sn'];
  % save output
  OUT = [OUT ;
         si OM' E EL STAT dV];
end

% sort output as a function of chi2
[Y,I] = sort(OUT(:,11+N),1,'ascend');
OUT_SORTED = OUT(I,:);
SITES_SORTED = SITES(I,:);

% best subset of sites
chi2_2 = OUT_SORTED(best,11+N);
chi2r_2 = OUT_SORTED(best,12+N);
dof_2 = OUT_SORTED(best,13+N);
disp(['-------------------------'])
tmp = [];
for i = 1:N
  tmp = [tmp cell2mat(SITES_SORTED(best,i)) ' '];
end
disp(['Best subset of sites: ' tmp]);
disp(['Chi2 = ' num2str(chi2_2)]);
disp(['Chi2_R = ' num2str(chi2r_2)]);
disp(['-------------------------'])
disp(['First 5: ']);
disp(SITES_SORTED(1:5,:));
disp(['-------------------------'])

% list of sites to test
test_sites = [1:nsites];
for s = [OUT_SORTED(best,[1:N])]
  I = find(test_sites~=s);
  test_sites = test_sites(I);
end

% test sites one by one
F = [];
for i = 1:length(test_sites)
  % extract the sites
  si = [OUT_SORTED(best,[1:N]) test_sites(i)];
  p = Pxyz(si,:);
  v = Vxyz(si,:);
  cv = CVxyz(si,:);
  ns = length(si);

  % compute angular rotation and statistics
  [OM,COM,E,EL,STAT,RES] = vel2rot(p,v,cv);

  % read stats
  chi2_1 = STAT(1);
  sig0 = STAT(2);
  dof_1 = STAT(3);

  % F TEST
    % compute F-statistics
    Fstat = ((chi2_1-chi2_2) / (dof_1-dof_2)) / (chi2_2/dof_2);
    % compute F-probability
    fp = f_cdf(Fstat,dof_1-dof_2,dof_2);

  % CHI2 TEST
    % get residual and its covariance for tested site
    Vres = RES(N,1:3)';
    Cres = [RES(N,4) RES(N,5) RES(N,6);
            RES(N,5) RES(N,7) RES(N,8);
            RES(N,6) RES(N,8) RES(N,9)];
    % compute X-statistics (=VtPV)
    Xstat = Vres' * inv(Cres) * Vres;
    % compute X-probability (for 3 degrees of freedom = 1 additional site)
    xp = chi2_cdf(Xstat,3);

  % STUDENT TEST (IN CONTEXT, I.E. TEST SITE INCLUDED IN POLE ESTIMATION)
    % form residual velocity for tested site
    V = sqrt(Vres(1)^2+Vres(2)^2+Vres(3)^2);
    % form Jacobian for f=sqrt(x^2+y^2+z^2)
    %J = [Vres(1)/(2*V) Vres(2)/(2*V) Vres(3)/(2*V)];
    J = [Vres(1)/V Vres(2)/V Vres(3)/V];
    % propagate variance
    C = J * Cres * J';
    % compute S-statistics ( = 'studentized residual')
    Sstat = abs(V) / (sqrt(sig0)*sqrt(C));
    % compute S-probability (for 3N-3 degrees of freedom)
    sp = student_cdf(Sstat,0,1,3*ns-3);

  % save output
  F = [F ; test_sites(i) chi2_1 sig0 fp xp sp];
end

% sort results acording to chi2
[Y,I] = sort(F(:,2),1,'ascend');
F = F(I,:);
test_sites = test_sites(I);

% display results
disp(['Test results when adding sites to best subset:']);
S = sprintf('site      chi2  chi2_r  Fp%%  Xp%%  Sp%%'); disp(S);
for i=1:length(test_sites)
  S = sprintf('%s %10.3f %5.2f %5.2f %5.1f %5.1f', cell2mat(site(test_sites(i))), ...
              F(i,2), F(i,3), F(i,4)*100, F(i,5)*100, F(i,6)*100);
  disp(S);
end
disp(['-------------------------'])

