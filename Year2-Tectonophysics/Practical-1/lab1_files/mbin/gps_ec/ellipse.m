function ellipse(a,b,t,p,l,map)

% ELLIPSE	Draw an ellipse with
%			semi-major axis a
%			semi-minor axis b
%			azimuth of semi-major axis t (degres CW)
%		at location (p,l)
%			if map = 0 => use plot
%			if map = 1 => use plotm (p=lon,l=lat)
%		Call: ellipse(a,b,t,p,l,map);

t = t*pi/180;

n = 0:0.05:2*pi ;

x = b*sin(n);
y = a*cos(n);

% build rotation matrix
R = [cos(t) sin(t);-sin(t) cos(t)];

% rotate ellipse
XYR = R * [x;y];
xr = XYR(1,:);
yr = XYR(2,:);

%plot ellipse
xr = p+xr;
yr = l+yr;
if (map == 0)
  plot(xr,yr);
elseif (map == 1)
  plotm(yr,xr);
end

