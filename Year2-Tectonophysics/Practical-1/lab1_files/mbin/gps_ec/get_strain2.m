function M = get_strain2(lon,lat,ve,vn);

% GET_STRAIN    Computes strain rates from velocities (horizontal)
%               lon, lat in degrees
%               ve, vn in mm/yr
%               M = [lono lato e1 e2 azim dire w exx exy eyy si c];
%                       e1, e2 = principal axes
%                       azim = azimuth of e1 (CCW from N)
%                       dire = directin of e1 (CCW from E)
%                       exx, exy, eyy = strain rate tensor
%                       si = second invariant
%                       w = rotation rate tensor
%               Call: M = get_strain1(lon,lat,ve,vn);


% Earth's radius
Er = 6471000;

% compute Delaunay triangulation
tri = delaunay(lon,lat);

% result matrix
M = [];

% for each Delaunay triangle
for j=1:size(tri,1)

  % read data from triangle j
  lon_tmp = lon(tri(j,:));
  lat_tmp = lat(tri(j,:));
  ve_tmp = ve(tri(j,:)).*1e3;
  vn_tmp = vn(tri(j,:)).*1e3;

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
          x(i) y(i)   0    0;
            0    0  x(i) y(i)];
    L = [ L;
         vx(i);
         vy(i)];
  end

  % solve for velocity gradient tensor
  c = cond(A'*A);
  S = pinv(A) * L;
  exx = S(1); exy = S(2); eyx= S(3); eyy = S(4);

  % velocity gradient tensor
  E = [ exx exy  ;
        eyx eyy ];

  % strain rate tensor
  EPS = 0.5 * (E + E');
  epsxx = EPS(1,1);
  epsxy = EPS(1,2);
  epsyx = EPS(2,1);
  epsyy = EPS(2,2);

  % rotation rate tensor
  W = 0.5 * (E - E');
  w = W(1,2);

  % compute principal strain axes
  e1 = 0.5*(epsxx+epsyy) + sqrt((epsxx-epsyy)^2/4+epsxy^2);
  e2 = 0.5*(epsxx+epsyy) - sqrt((epsxx-epsyy)^2/4+epsxy^2);
  azim = -0.5*atan2(2*epsxy,(epsxx-epsyy));
  dire = 0.5*atan2(2*epsxy,(epsxx-epsyy));
  azim = azim*180/pi;
  dire = dire*180/pi;

  % compute second invariant
  si = (1/sqrt(2)) * sqrt(abs(epsxy*epsyx + epsxx*epsyy));

  % compute "location" of strain tensor
  lono = mean(lon_tmp);
  lato = mean(lat_tmp);

  % fill out result matrix
  M = [M;
       lono lato max(e1,e2) min(e1,e2) azim dire w exx exy eyy si c];
end

