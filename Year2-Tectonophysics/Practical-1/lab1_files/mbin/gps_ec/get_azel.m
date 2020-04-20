function AZEL = get_azel(rnx_file,eph_file,plot,POS);

% GET_AZEL	Computes azimuth and elevation for satellites in
%		broadcast ephemerides file eph_file at epochs found
%		in rinex observation file rnx_file.
%
%		Input:
%		  rnx_file = observation rinex file name
%		  eph_file = ephemerides rinex file name
%		  plot = y/n to show skyplot
%               Optional input:
%                 POS = site position [lat lon height]
%		Output:
%		  AZEL = n x 5 matrix with n = number of epochs found
%		  and column 1 = satellite PRN number
%		      column 2 = time in decimal hours
%                     column 3 = azimuth in radians
%                     column 4 = elevation angle in radians
%                     column 5 = zenith angle in radians
%
%		Usage: AZEL = get_azel(rnx_file,eph_file,plot);

% defaults
obs = 'C1';	% observable to use for position calculation
iter = 1;	% number of iterarions for position calculation
decim = 10;	% decimation factor for position calculation

% read site position, if provided
if (nargin == 4)
  latR = POS(1);
  lonR = POS(2);
  altR = POS(3);
  get_position = 'n';
else
  get_position = 'y';
end

% message
disp(['-------------']);
disp(['Running get_azel for files:']);
disp(['--> rinex observations: ' rnx_file]);
disp(['--> rinex ephemerides: ' eph_file]);

%observations find date
doy = str2num(rnx_file(5:7));
year = str2num(rnx_file(10:11));
if(year >= 80) then
   year = year + 1900;
else
   year = year + 2000;
end
[week,dow,mjd] = gweek(year,doy);

% read rinex file (just to get list of SVs)
disp(['-------------']);
disp(['Reading rinex observation file...']);
[Observables,epochs,sv,apcoords]=readrinex(rnx_file);

% compute time vector of observations in seconds
Tobs = epochs(:,4)*3600 + epochs(:,5)*60 + epochs(:,6);

% read rinex navigation file
[eph,alpha,beta] = read_rinexn(eph_file);

% compute site position, if necessary
if (get_position == 'y')
  % calculate epoch-by-epoch position
  [L,SL,X,G,PDOP,T] = get_pos(rnx_file,eph_file,obs,iter,decim);

  % calculate mean position
  latR = mean(G(:,1)); lonR = mean(G(:,2)); altR = mean(G(:,3));
  disp(['Mean site position:']);
  disp(['Latitude: ' num2str(latR)]);
  disp(['Longitude: ' num2str(lonR)]);
  disp(['Height: ' num2str(altR)]);
end

% compute satellite position at each epoch in rinex observation file
disp(['-------------']);
disp(['Computing satellite positions...']);
DT = dow*24*3600;
PR = Observables.C1;
S = [];
for i = 1:length(Tobs)
  % find satellites visible
  I = find(~isnan(PR(i,:)));
  sat = sv(I);
  % for each satellite visible
  for j=1:length(sat)
    % get satellite position at Tobs+DT
    satpos = get_satpos(Tobs(i)+DT,sat(j),eph,0);
    if (~isempty(satpos))
      % write satellite position matrix
      S = [S; satpos(1:3)' sat(j) Tobs(i)+DT];
    end
  end
end

% now calculate elevations and azimuths
[XR,YR,ZR] = wgs2xyz(lonR,latR,altR);
AZEL = [];
disp(['-------------']);
disp(['Computing elevation and azimuth...']);
for (i=1:length(sv))
  % grep satellite position in S
  I = find(S(:,4)==sv(i));
  % matrix of satellite positions (meters)
  P = [S(I,1) S(I,2) S(I,3)];
  % compute elevation angle, range, and azimuth
  [azim,elev,hlen] = azelle(P,[XR,YR,ZR]);
  % convert elevation to zenith angle
  zen_ang = (pi/2) - elev;
  % convert time back to decimal hours
  t = (S(I,5) - DT) ./ (24*3600);
  % write output
  AZEL = [AZEL ; S(I,4) S(I,5) azim elev zen_ang];
end

% plot (or not)
if (plot == 'y')
  disp(['-------------']);
  disp(['Plotting skyplot']);
  polar(0,90); hold on;
  polar(AZEL(:,3),AZEL(:,5).*180/pi,'.r');
  title(['skyplot for ' rnx_file ' - ' eph_file]);
end

% end message
disp(['-------------']);
disp(['Done.']);
