function [D,T,m,s] = comp_orb(sp3_file,nav_file,sv,opt);

% COMP_ORB	Compares satellite orbit for sp3 and nav file
%		and produces a plot of differences.
%
%		Usage: [D,T,m,s] = comp_orb(sp3_file,nav_file,sv);
%		Input:
%		- sp3_file = sp3 file name
%		- nav_file = rinex navigation file
%		- sv = satellite PRN number
%		- opt = plot (1) or not (0)
%		Output:
%		- D = range diference (meters)
%		- T = correponding time vector (hours of day)
%		- m = mean of range difference (meters)
%		- s = std. dev. of range difference (meters)
%
%		Uses: read_sp3, read_rinexn, get_satpos

% read sp3 file
[X,Y,Z,dT,TT] = read_sp3(sp3_file,sv);

% figure out day of week and calculate offset in seconds
dow = sp3_file(8);
DT = dow*24*3600;

% read navigation file
[eph,alpha,beta] = read_rinexn(nav_file);

% get satellite position for each time in Ts
Xb=[]; Yb=[]; Zb=[]; Tb=[]; % initialize nav vector
Xs=[]; Ys=[]; Zs=[]; Ts=[]; % initialize sp3 vector
for i = 1:length(TT)
  satpos = get_satpos(TT(i)+DT,sv,eph,1);
  if (~isempty(satpos))
    Xb = [Xb satpos(1)]; Yb = [Yb satpos(2)]; Zb = [Zb satpos(3)];
    Tb = [Tb satpos(4)]; 
    Xs = [Xs X(i)]; Ys = [Ys Y(i)]; Zs = [Zs Z(i)]; Ts = [Ts TT(i)]; 
  end
end

% convert ECEF sat. positions to range
SP3 = sqrt(Xs.^2+Ys.^2+Zs.^2).*1000;
BRD = sqrt(Xb.^2+Yb.^2+Zb.^2);

% calculate range difference
D = BRD-SP3;
T = Ts/3600;

% mean + std
m = mean(D);
s = std(D);
disp(['PRN' num2str(sv) ': mean = ' num2str(m) ' m - std = ' num2str(s) ' m' ]);

% plot
if (opt == 1)
  plot(T,D,'b')
  xlabel(['Time (hours)']);
  ylabel(['Range difference (m)']);
  title([sp3_file ' - ' nav_file ' for PRN' num2str(sv)]);
end

