function [L,SL,X,G,PDOP,T] = get_pos(rnx_file,eph_file,sp3_file,obs,iter,decim);

% GET_POS	Compute epoch-by-epoch positions from pseudorange data.
%
%		Input:  rnx_file = rinex observation file
%		        eph_file = rinex navigation file
%		        sp3_file = sp3 orbit file
%             obs = observable, can be C1, P1, or P2
%             iter = number of iterations
%             decim = decimation factor (i.e., use of epoch every decim,
%                     use 1 for processing every epoch)
%		Output: L  = positions, NEU frame (m), 3 x n matrix
%		        SL = uncertainties, NEU (m), 3 x n matrix
%		        X  = positions, XYZ frame (m), 3 x n matrix
%		        G  = positions, geodetic frame, 3 x n matrix
%             PDOP = PDOP vector
%             T = time vector in decimal hours
%
%      Usage:
%             [L,SL,X,G,PDOP,T] = get_pos(rnx_file,eph_file,obs,iter,decim);

% read rinex file
disp(['-------------']);
[Observables,epochs,sv,apcoords] = readrinex(rnx_file);

% find date
doy = str2num(rnx_file(5:7));
year = str2num(rnx_file(10:11));
if (year >= 80) then
   year = year + 1900;
else
   year = year + 2000;
end
[week,dow,mjd] = gweek(year,doy);

% a priori site position
apr_pos = [apcoords;0];

% choose observable
if (obs=='C1' & isfield(Observables,'L1'))
  PR = Observables.C1;
elseif (obs=='P1' & isfield(Observables,'P1'))
  PR = Observables.P1;
elseif (obs=='P2' & isfield(Observables,'P2'))
  PR = Observables.P2;
end
if (isempty(PR))
  disp(['ERROR: pseudorange vector is empty']);
  return;
else
  disp(['Using ' obs ' pseudorange']);
end

% compute time vector of observations in seconds
T = epochs(:,4)*3600 + epochs(:,5)*60 + epochs(:,6);

% find sampling rate
tmp = [T;0]-[0;T];
splint = round(mean(tmp(1:end-1)));
disp(['Found sampling interval of ' num2str(splint) ' seconds']);

% read navigation file
disp(['-------------']);
disp(['Reading ephemerides...']);
eph = read_rinexn(eph_file);

% read sp3 orbit file
[SAT,svsp3] = interp_sp3(sp3_file, splint);

% figure out day of week and calculate offset in seconds
DT = dow*24*3600;

% initialize output
X    = [];
SX   = [];
SL   = [];
G    = [];
PDOP = [];
t    = [];

disp(['-------------']);
disp(['Computing epoch-by-epoch solution...']);
disp(['Using ' num2str(length(T)) ' epochs']);
disp(['Decimation factor = ' num2str(decim)]);

% decimation
J = [1:length(T)];
EP = find(~mod(J,decim));
disp(['Computing solution at ' num2str(length(EP)) ' epochs']);

% for each epoch
for i = 1:length(EP)

  % epoch to process
  ep = EP(i);

  % find satellites visible
  I = find(~isnan(PR(ep,:)));
  sat = sv(I);

  % extract corresponding pseudorange
  P = PR(ep,I);

  % extract satellite positions
  S = [];
  excl = [];
  incl = [];
  % for each satellite visible
  for j=1:length(sat)
    % get satellite position at T+DT
    satpos = get_satpos(T(ep)+DT,sat(j),eph,0);

%%%%
xyz = satpos(1:4);
eval(['tsp3 = SAT.PRN' num2str(sat(j)) '(1,:);']);
teph = T(ep)/3600;
dTeph = xyz(4);
% find observation time in sp3 data
[ttmp,l] = min(abs(tsp3'-teph));
% if (ttmp ~= 0) WARNING MESSAGE - did not find requested epoch in interpolated sp3 data
eval(['tsp3 = SAT.PRN' num2str(sat(j)) '(1,l);']);
eval(['satpos = SAT.PRN' num2str(sat(j)) '(2:5,l);']);
eval(['dTsp3 = SAT.PRN' num2str(sat(j)) '(5,l);']);
dR = sqrt(satpos(1)^2+satpos(2)^2+satpos(3)^2) - sqrt(xyz(1)^2+xyz(2)^2+xyz(3)^2);
%disp([num2str(sat(j)) ' ' num2str(T(ep)/3600) ' ' num2str(tsp3) ' ' num2str(dR) ' ' num2str(abs(dTsp3-dTeph))]);


    % exclude if no data for that PRN
    if (isempty(satpos))
      excl = [excl j];
    % exclude if large difference between eph and sp3 PRN bias
    %elseif (abs(dTsp3-dTeph) > 0.000000005)
    %  excl = [excl j];
    % else if PRN ok
    else
      % convert XYZ from m to km
      satpos(1:3) = satpos(1:3) / 1000;
      % convert clock bias from seconds to microsec
      %satpos(4) = satpos(4) * 1e6;
      satpos(4) = xyz(4) * 1e6;
      % write satellite position matrix
      S = [S satpos(1:4)];
      incl = [incl j];
    end
  end

  % rewrite pseudorange vector if PRNs are excluded
  if ~(isempty(excl))
    %disp(['Epoch ' num2str(ep) ', excluding ' num2str(length(excl)) ' satellites']);
    excl_prn = [];
    for k=1:length(excl)
      excl_prn = [excl_prn sv(excl(k))];
    end
    %disp(['Excluded PRNs: ' num2str(excl_prn)]);
    P = P(incl);
  end

  % if enough data
  if (length(P) >= 4)
    % run iterations
    for k=1:iter
      % solve for site position
      [A, DA, SA, E, SE, DOP] = solve_PR(apr_pos,S,P');
      % new a priori position for next iteration
      apr_pos = A;
    end
 
    % increment result matrices and vectors
    X    = [X; A];     % positions in ECEF
    SX   = [SX; SA];   % formal errors in ECEF
    SL   = [SL; SE];   % formal errors in NEU
    G    = [G; E];     % ellipsoidal positions
    PDOP = [PDOP; DOP(3)];
    t    = [t; T(ep)];
  else
    disp(['Epoch ' num2str(ep) ' not enough data']);
  end

end

% convert ECEF to local NEU coordinates
x = ones(size(X,1),1) .* apr_pos(1);
y = ones(size(X,1),2) .* apr_pos(2);
z = ones(size(X,1),3) .* apr_pos(3);
[L,CL] = xyz2neu(apr_pos,X,SX,zeros(length(X),3));

% convert time to decimal hours
T = t ./ 3600;

disp(['Done']);
disp(['-------------']);
