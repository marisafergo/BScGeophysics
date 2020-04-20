function [OM,COM,E,EL,chi2,chi2r,dof,rmsNEH] = psvelo2rot(in_file,sig_max,std_scale);

% PSVELO2ROT	Estimates plate angular rotation and associated statistics
%              from psvelo input file.
%
%     Usage:
%       [OM,COM,E,EL,chi2,chi2r,dof,rmsNEH] = psvelo2rot(in_file,sig_max,std_scale);
%
%		Input:
%		  in_file = input velocity file in psvelo format (mm/yr)
%		  sig_max = minimum velocity uncertainty (mm/yr)
%		  std_scale = std. dev. scaling factor
%		Output:
%       OM = Wx  Wy   Wz     (deg/My)
%       COM = [XX  XY  XZ
%              XY  YY  YZ
%              XZ  YZ  ZZ]   (deg/My)**2
%       E = Lat (deg)  Lon (deg)  Ang (deg/My)
%       EL = Semi-max  Semi-min   Azim (deg)  Ang (deg/My)
%       chi2, chi2, dof
%       rmsNEH  rms N E H  (mm/yr)
%              wrms N E H  (mm/yr)
%		Note: uses matlab routines from ~/Matlab/stats/
%       addpath ~/Matlab/gps_ec/
%       addpath ~/Matlab/stats/

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

% rescale variances
sve = sve .* std_scale;
svn = svn .* std_scale;
svu = svu .* std_scale;

% convert site positions and velocities to cartesian and m/yr
disp(['Converting positions and velocities to cartesian']);
[x,y,z] = wgs2xyz(lon,lat,h);
Pxyz = [x y z];
O = [lat lon h];
% make sure velocities are converted to m/yr
Vneu = [vn ve vu] ./ 1000.0;
SVneu = [svn sve svu] ./ 1000.0;
CORneu = [cne cnu ceu]; %%% rjw ./ (1000.0^2);
[Vxyz,CVxyz] = neu2xyz(O,Vneu,SVneu,CORneu);

% compute angular rotation and statistics
disp(['Computing angular velocity and statistics']);
[OM,COM,E,EL,STAT,RES] = vel2rot(Pxyz,Vxyz,CVxyz);
COM = [COM(1,1) COM(1,2) COM(1,3) COM(2,2) COM(2,3) COM(3,3)]; %%% rjw .*(1000.0^2);
chi2 = STAT(1);
chi2r = STAT(2);
dof = STAT(3);

% extract residuals and covariance matrix of residuals
Vres = RES(:,1:3);
CVres = [RES(:,4) RES(:,5) RES(:,6) RES(:,7) RES(:,8) RES(:,9)];

% sum variance of observations + variance of residuals
Ctot = CVres; %% rjw +CVxyz already been summed in vel2rot, no need to do again
SV = sqrt([Ctot(:,1) Ctot(:,4) Ctot(:,6)]);
COR = [Ctot(:,2)./(Ctot(:,1).^0.5 .* Ctot(:,4).^0.5)  Ctot(:,3)./(Ctot(:,1).^0.5 .* Ctot(:,6).^0.5) Ctot(:,5)./(Ctot(:,4).^0.5 .* Ctot(:,6).^0.5)]; %%%rjw

% convert residuals to NEU
[VRneu,CRneu,LLH] = xyz2neu(Pxyz,Vres,SV,COR);
VRneu = VRneu .* 1000;
CRneu = CRneu .* (1000^2);
SVRneu = sqrt([CRneu(:,1) CRneu(:,4) CRneu(:,6)]);
R = [LLH(:,2) LLH(:,3) VRneu(:,2) VRneu(:,1) SVRneu(:,2) SVRneu(:,1) CRneu(:,2)./(SVRneu(:,2).*SVRneu(:,1))];

% compute weighted mean of residuals
[wmean_N,wrms_N] = get_wrms(VRneu(:,2),SVRneu(:,2));
[wmean_E,wrms_E] = get_wrms(VRneu(:,1),SVRneu(:,1));
[wmean_H,wrms_H] = get_wrms([VRneu(:,1);VRneu(:,2)],[SVRneu(:,1);SVRneu(:,2)]);

%compute rms %%% rjw
rms_N = sqrt(mean(VRneu(:,2).^2));
rms_E = sqrt(mean(VRneu(:,1).^2));
rms_H = sqrt(mean([VRneu(:,1);VRneu(:,2)].^2));

rmsNEH = [rms_N  rms_E rms_H ; wrms_N  wrms_E wrms_H];

disp(['-------------------------'])
S = sprintf('ANGULAR VELOCITY:      Wx          Wy          Wz     (deg/My)'); disp(S);
S = sprintf('                    %7.4f     %7.4f     %7.4f\n',OM); disp(S);
S = sprintf('COVARIANCE ELMTS:    XX      XY      XZ      YY      YZ      ZZ   (deg/My)**2'); disp(S);
S = sprintf('                  %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f\n',COM); disp(S);
S = sprintf('ROTATION PARAMETERS:  Lon (deg)   Lat (deg)   Ang (deg/My)'); disp(S);
S = sprintf('                      %7.4f     %7.4f     %7.4f\n',E); disp(S);
S = sprintf('STANDARD ERROR ELLIPSE: Semi-max  Semi-min   Azim (deg)  Ang (deg/My)'); disp(S);
S = sprintf('                        %7.4f   %7.4f    %7.4f   %7.4f\n',EL); disp(S);
S = sprintf('STATISTICS:'); disp(S);
S = sprintf('  CHI**2            : %.2f', chi2); disp(S);
S = sprintf('  DEGREES OF FREEDOM: %d', dof); disp(S);
S = sprintf('  REDUCED CHI**2    : %.2f', chi2r); disp(S);
S = sprintf('\nRESIDUALS (mm/yr):'); disp(S);
S = sprintf('   Lon       Lat    Ve    Vn    Sve   Svn    Corr   Site'); disp(S);
for i=1:nsites
  S = sprintf('%8.3f %8.3f %5.2f %5.2f %5.2f %5.2f %8.5f  ',R(i,:));
  disp([S cell2mat(site(i))]);
end
S = sprintf('\nWEIGHTED MEAN OF RESIDUALS:'); disp(S);
S = sprintf('    North = %.1f +- %.1f mm/yr',wmean_N,wrms_N); disp(S);
S = sprintf('    East  = %.1f +- %.1f mm/yr',wmean_E,wrms_E); disp(S);
S = sprintf('    Horiz = %.1f +- %.1f mm/yr',wmean_H,wrms_H); disp(S);

% rewrite covariance matrix
COM = [COM(1) COM(2) COM(3);
       COM(2) COM(4) COM(5);
       COM(3) COM(5) COM(6)];

%hist([VRneu(:,1);VRneu(:,2)],10);
