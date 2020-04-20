function skyplot(sp3file,sv,latR,lonR,altR,cutoff);

% SKYPLOT	o%Produces satellite skyplot from sp3 file.
%           Input:
%             sp3file = an orbit file in sp3 format
%             sv = vector of PRN numbers
%             latR, lonR, altR = ground site position (WGS)
%             cutoff = elevation cutoff angle in degrees
%
%           Call: skyplot(sp3file, sv, latR, lonR, altR, cutoff)

polar(0,90);
hold on;

disp(['-------------']);
disp(['Producing sky plot...']);

for (i=1:length(sv))
  % read sp3 file for satellite sv
  [Xs,Ys,Zs,dT,Ts] = read_sp3(sp3file,sv(i));

  % convert sp3 to meters
  Xs = Xs.*1000;
  Ys = Ys.*1000;
  Zs = Zs.*1000;

  % matrix of satellite positions (ECEF, meters)
  S = [Xs Ys Zs];

  % convert reference site to ECEF
  [XR,YR,ZR] = wgs2xyz(lonR,latR,altR);

  % compute elevation angle, range, and azimuth
  [azim,elev,hlen] = azelle(S,[XR,YR,ZR]);

  % convert elevation to zenith angle
  zen_ang = (pi/2) - elev;

  % cutoff observations below cutoff angle
  cutoff = cutoff * pi/180;
  I = find(zen_ang<((pi/2)-cutoff));

  % sky plot
  polar(azim(I),zen_ang(I).*180/pi,'*b');
  %h = mmpolar(azim(I),zen_ang(I).*180/pi,'*b','TZeroDirection','North','RLimit',[0 90]);

end

