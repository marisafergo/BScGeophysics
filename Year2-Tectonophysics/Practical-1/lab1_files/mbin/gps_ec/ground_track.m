function ground_track(sp3file,sv);
 
% GROUND_TRACK  Produces satellite ground track plot from sp3 file
%               Call: ground_track(sp3file, sv)
%               sv is a vector of PRN numbers

% make map
load coast;
latlim = [-80 80];
lonlim = [0 360];
axesm('MapProjection','mercator',...
      'MapLatLimit',latlim,'MapLonLimit',lonlim,...
      'MLabelLocation',30,'MLineLocation',10,...
      'PLabelLocation',30,'PLineLocation',10,...
      'LabelFormat','signed');
mlabel; plabel; framem;
plotm(lat,long,'LineWidth',1,'Color','blue');

% calculate and plot ground tracks
for (i=1:length(sv))
  % read sp3 file for satellite sv(i)
  [Xs,Ys,Zs,dT,Ts] = read_sp3(sp3file,sv(i));

  % convert ECEF position to geodetic
  R = xyz2wgs([Ts Xs Ys Zs]);

  % plot ground track
  plotm(R(:,3),R(:,2),'r*');

end

