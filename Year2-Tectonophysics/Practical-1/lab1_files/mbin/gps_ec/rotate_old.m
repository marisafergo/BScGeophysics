function V = rotate(OM,P)

% ROTATE	Computes velocity of point P(X,Y,Z) located
%		on a plate that moves according to rotation vector
%		OM(Rx,Ry,Rz) (deg/my).
%		P can be a vector or a n x 3 matrix with n site positions (m)
%		V will be a vector or a n x 3 matrix with n site velocities (m/yr)
%		Call: V = rotate(OM,P);

% convert OM to m/y
OM = OM .* 0.11119493;

% compute unit vector
X = P(:,1); Y = P(:,2); Z = P(:,3);
R = sqrt(X.^2+Y.^2+Z.^2);
P = [X./R Y./R Z./R];
x = P(:,1); y = P(:,2); z = P(:,3);

if (size(P,1) > 1)
  % make OM it into a n x 3 matrix for faster cross product
  Jx = ones(size(P,1),1) .* OM(1);
  Jy = ones(size(P,1),1) .* OM(2);
  Jz = ones(size(P,1),1) .* OM(3);
  OM = [Jx Jy Jz];

  % cross product: V = OM x P
  V = cross(OM,P,2);

else
  V = cross(OM,P);

  A = [ 0  z -y;
       -z  0  x;
        y -x  0];
  V = A * OM';
end
