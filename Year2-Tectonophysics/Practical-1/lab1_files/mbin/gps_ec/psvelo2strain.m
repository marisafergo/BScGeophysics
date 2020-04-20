%function R = psvelo2strain(in_file,scale);

% DELAUNEY_STRAIN	Compute strain rates from horizontal velocities provided
%                 in psvelo format using a Delauney triangulation.
%
%                 in_file = psvelo file
%                    lon, lat = site coordinates in degrees
%                    ve, vn = site velocities in mm/yr
%                    sve, svn = std. dev. on site velocities in mm/yr
%                    cne = sve/svn correlation
%                 scale = scaling factor for uncertainties
%
%                 R = [lono lato e1 e2 azim dire w epsxx epsxy epsyy area];
%                   e1, e2 = principal strains
%                   azim = azimuth of e1 (CCW from N)
%                   dire = directin of e1 (CCW from E)
%                   epsxx, epsxy, epsyy = strain rate tensor
%                   w = rotation rate tensor
%                   area = triangle area

% read psvelo input file
[lon,lat,ve,vn,sve,svn,cne,site,v]=textread(in_file,'%f %f %f %f %f %f %f %s %f');

% convert to meters and scale uncertainties
ve = ve .* 1e-3; vn = vn .* 1e-3;
sve = sve .* 1e-3 * scale; svn = svn .* 1e-3 * scale;

% compute Delaunay triangulation
tri = delaunay(lon,lat);
disp(['Found ' num2str(size(tri,1)) ' Delaunay triangles']);

% result matrix
R = [];

% for each Delaunay triangle
for j=1:size(tri,1)
  disp(['Working on triangle ' num2str(j)]);

  % initialize output
  M = [];

  % read data for triangle j
  lon_tmp = lon(tri(j,:));
  lat_tmp = lat(tri(j,:));
  ve_tmp = ve(tri(j,:));
  vn_tmp = vn(tri(j,:));
  sve_tmp = sve(tri(j,:));
  svn_tmp = svn(tri(j,:));

  % form covariance matrix
  V = zeros(6,6);
  for i=1:3
    V(2*i-1:2*i,2*i-1:2*i) = [ sve_tmp(i)^2 cne(i)      ;
                               cne(i)      svn_tmp(i)^2];
  end

  % compute strain
  M = get_strain(lon_tmp,lat_tmp,ve_tmp,vn_tmp,V,0);

  % compute triangle area
  P = [lon_tmp.*(pi/180).*6471 lat_tmp.*(pi/180).*6471 [1;1;1]];
  A = abs(det(P)) / 2;

  % fill up result matrix
  R = [R ; M A];

end

