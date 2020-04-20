function plot_strain(M,lon,lat,ve,vn,scale);

% PLOT_STRAIN	Plots principal strains given in M matrix (see get_strain)
%
%              M = output of get_strain or of psvelo2strain
%                 M = [lono lato e1 e2 azim dire omega epsxx epsxy epsyy snd];
%                       e1, e2 = principal strains, 10^-9 /year
%                       azim = azimuth of e1 (CCW from N), degrees
%                       dire = directin of e1 (CCW from E), degrees
%                       omega = rotation rate, degree/Myr
%                       epsxx, epsxy, epsyy = strain rate tensor, 10^-9/yr
%                       se1, se2 = std.dev. of e1, e2, 10^-9/yr
%                       snd, ssnd = second invariant + std. dev., 10^-9/yr
%                   If produced by psvelo2strain, last column is triangle area
%
%              lon, lat, ve, vn = position and velocities of the sites
%                                 used for strain calculation
%              scale = arbitrary scaling factor to plot ppal strain (try 1e-3)
%
%		RED = extension
%		BLUE = compression
%
%		Call: plot_strain(M,lon,lat,ve,vn,scale);

% compute delaunay triangulation
tri = delaunay(lon,lat);

% compute coordinates of principal strain axes in (x,y) frame
M(:,6) = M(:,6) .* pi/180;
e1x = M(:,3) .* cos(M(:,6));
e1y = M(:,3) .* sin(M(:,6));
e2x = -M(:,4) .* sin(M(:,6));
e2y = M(:,4) .* cos(M(:,6));

% revert colormap for patches
figure;
C = hot;
for j=1:size(C,1)
  newmap(j,:) = C(size(C,1)+1-j,:);
  j = j+1;
end

for j=12:-1:11
  % read second invariant of strain tensor
  % then uncertainty
  si = M(:,j);

  % plot patch with second invariant color
  subplot(2,1,j-10); hold on;
  if (j==12) title(['Standard deviation (nanostrain/yr)']); end;
  axis equal;

  XP = [];
  YP = [];
  for j=1:size(tri,1)
    XP = [XP ; lon(tri(j,:))'];
    YP = [YP ; lat(tri(j,:))'];
  end
  colormap(newmap);
  patch(XP',YP',si');
  caxis([0 max(M(:,11))]);
  shading flat;
  colorbar;
end

for j=1:size(tri,1)
  plot([lon(tri(j,:));lon(tri(j,1))],[lat(tri(j,:));lat(tri(j,1))],'m:');
  %plot([x+vx;x(1)+vx(1)],[y+vy;y(1)+vy(1)],'m-');
  lono = M(j,1); lato = M(j,2);
  plot(lono,lato,'.');

  if M(j,3) > 0 % extension
    plot([lono;lono+scale*e1x(j)],[lato;lato+scale*e1y(j)],'r-');
    plot([lono;lono-scale*e1x(j)],[lato;lato-scale*e1y(j)],'r-');
    plot(lono+scale*e1x(j),lato+scale*e1y(j),'rx');
    plot(lono-scale*e1x(j),lato-scale*e1y(j),'rx');
  else % compression
    plot([lono;lono+scale*e1x(j)],[lato;lato+scale*e1y(j)],'b-');
    plot([lono;lono-scale*e1x(j)],[lato;lato-scale*e1y(j)],'b-');
    plot(lono+scale*e1x(j),lato+scale*e1y(j),'bx');
    plot(lono-scale*e1x(j),lato-scale*e1y(j),'bx');
  end

  if M(j,4) > 0 % extension
    plot([lono;lono+scale*e2x(j)],[lato;lato+scale*e2y(j)],'r-');
    plot([lono;lono-scale*e2x(j)],[lato;lato-scale*e2y(j)],'r-');
    plot(lono+scale*e2x(j),lato+scale*e2y(j),'ro');
    plot(lono-scale*e2x(j),lato-scale*e2y(j),'ro');
  else % compression
    plot([lono;lono+scale*e2x(j)],[lato;lato+scale*e2y(j)],'b-');
    plot([lono;lono-scale*e2x(j)],[lato;lato-scale*e2y(j)],'b-');
    plot(lono+scale*e2x(j),lato+scale*e2y(j),'bo');
    plot(lono-scale*e2x(j),lato-scale*e2y(j),'bo');
  end

end
title(['RED = extension BLUE = shortening']);
