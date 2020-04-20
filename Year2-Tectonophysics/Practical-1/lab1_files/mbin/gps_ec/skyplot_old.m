function skyplot(sp3file, sv, latR, lonR, altR);

% SKYPLOT	Produces satellite skyplot
%	skyplot(sp3file, sv, latR, lonR, altR)
%	sp3file is an orbit file in sp3 format
%	sv is a PRN number
%	latR, lonR, altR describe the ground site position

fid=fopen(sp3file,'r');
Xs=[]; Ys=[]; Zs=[];
while 1
  line = fgetl(fid);
  if ~isstr(line), break, end
  if (line(1)=='P')
     [p] = sscanf(line, '%c %d %lf %lf %lf %f');
     if (p(2) == sv)
       Xs = [Xs;p(3)*1000]; Ys = [Ys;p(4)*1000]; Zs = [Zs;p(5)*1000];
     end
  end
end
fclose(fid);

% convert reference site to ECEF
[XR,YR,ZR] = wgs2xyz(lonR,latR,altR);

% compute ground-sat vector in ECEF coordinates
Rgs = [Xs-XR Ys-YR Zs-ZR];

% convert to unit vector
rang = sqrt(Rgs(:,1).^2+Rgs(:,2).^2+Rgs(:,3).^2);
Ru = [Rgs(:,1)./rang Rgs(:,2)./rang Rgs(:,3)./rang];

% XYZ to NEU rotation matrix
latR = latR*pi/180;
lonR = lonR*pi/180;
R = [-sin(latR)*cos(lonR) -sin(latR)*sin(lonR) cos(latR);
     -sin(lonR)            cos(lonR)           0        ;
      cos(latR)*cos(lonR)  cos(latR)*sin(lonR) sin(latR)];

% rotate ground-sat vector
neu = R * Ru';
neu = neu';

% convert neu to azimuth and elevation angle
hlen = sqrt(neu(:,1).^2+neu(:,2).^2);
zen_ang = atan2(hlen,neu(:,3));
azim = atan2(neu(:,2),neu(:,1));

% cutoff observations below horizon
cutoff = 1 * pi/180;
I = find(zen_ang<((pi/2)-cutoff));

% sky plot
%polar(azim(I),hlen(I),'.b');
polar(azim(I),zen_ang(I).*180/pi,'.b');
hold on;
