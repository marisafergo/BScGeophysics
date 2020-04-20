function M = get_strain1(lon,lat,ve,vn);

% GET_STRAIN	Computes strain rates from velocities (horizontal)
%		lon, lat in degrees
%		ve, vn in mm/yr
%		M = [lono lato e1 e2 azim dire w exx exy eyy c];
%			e1, e2 = principal axes
%			azim = azimuth of e1 (CCW from N)
%			dire = directin of e1 (CCW from E)
% 			exx, exy, eyy = strain rate tensor
%			w = rotation rate tensor
%		Call: M = get_strain1(lon,lat,ve,vn);

% Earth's radius
Er = 6471000;

% compute delaunay triangulation
tri = delaunay(lon,lat);

% result matrix
M = [];

% for each triangle
for j=1:size(tri,1)

  % read data from triangle j
  lon_tmp = lon(tri(j,:));
  lat_tmp = lat(tri(j,:));
  ve_tmp = ve(tri(j,:));
  vn_tmp = vn(tri(j,:));

  % convert lat lon from degrees to meters and w.r.t. reference point
  x = (lon_tmp - lon_tmp(1)) .* pi/180 .* Er;
  y = (lat_tmp - lat_tmp(1)) .* pi/180 .* Er;

  % convert ve vn from mm/yr to m/yr and w.r.t. reference point
  vx = (ve_tmp - ve_tmp(1)) .* 1e-3;
  vy = (vn_tmp - vn_tmp(1)) .* 1e-3;

  % setup design matrix and observation vector
  A = [];
  L = [];
  num_nodes = length(x);
  % start at 2 because first equations are empty
  for i=2:num_nodes
    A = [ A;
          x(i) y(i)   0   y(i);
           0   x(i) y(i) -x(i)];
    L = [ L;
         vx(i);
         vy(i)];
  end

  % solve for strain and rotation
  c = cond(A'*A);
  S = pinv(A) * L;
  exx = S(1); exy = S(2); eyy = S(3); w = S(4);

  % strain rate tensor
  E = [ exx exy  ;
       -exy eyy ];

  % rotation rate tensor
  W = [ 0  w ;
       -w  0];

  % compute principal strain axes
  e1 = 0.5*(exx+eyy) + sqrt((exx-eyy)^2/4+exy^2);
  e2 = 0.5*(exx+eyy) - sqrt((exx-eyy)^2/4+exy^2);
  azim = -0.5*atan2(2*exy,(exx-eyy));
  dire = 0.5*atan2(2*exy,(exx-eyy));
  azim = azim*180/pi;
  dire = dire*180/pi;

  % compute "location" of strain tensor
  lono = mean(lon_tmp);
  lato = mean(lat_tmp);

  % fill out result matrix
  M = [M;
       lono lato max(e1,e2) min(e1,e2) azim dire w exx exy eyy c];
end

