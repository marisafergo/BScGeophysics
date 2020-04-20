function [iec,iec_dot] = get_ion(L1,L2,C1,P1,P2)

% GET_ION	Computes ionospheric electron content
%	[iec,iec_dot] = get_ion(L1,L2,C1,P1,P2)
%	L1, L2, C1, P1, P2 are observables matrices (output of read_rinexo)
%	iec is the output electron content
%	iec_dot is its time derivative

% constant
A = 40.3;

% L1 and L2 frequencies
f1 = 1.57542e9;
f2 = 1.2276e9;
c = 0.299792458e9;
l1 = c/f1;
l2 = c/f2;

% multiplication factor
F = (f1^2*f2*c) / (A * (f1^2-f2^2));

% number of satellites
nsat = size(L1,2);

% number of observations
nobs = size(L1,1);

% compute PG and LG
if (isempty(P1))
  PG = (f2/c) * (P2-C1);
else
  PG = (f2/c) * (P2-P1);
end
LG = (L2 - (f2/f1)*L1);
%cet = F * LG;
%ion = (f1^2/(f1^2-f2^2)) * (L2.*l2 - L1.*l1);

% compute (P2-P1) offset here and apply to LG

% initialize arrays
iec = zeros(nobs,nsat);
iec_dot = zeros(nobs,nsat);

% for each satellite
for i = 1:nsat
   x = [0 ; PG(:,i)./(PG(:,i)+eps^2)];
   y = [PG(:,i)./(PG(:,i)+eps^2) ; 0];
   z = x - y;
   I = find(z);
   % foreach data segment
   for j = 1:2:length(I)
      B = mean(PG(I(j):I(j+1)-1,i)+LG(I(j):I(j+1)-1,i));
      iec(I(j):I(j+1)-1,i) = F * (B - LG(I(j):I(j+1)-1,i));
      iec_dot(I(j):I(j+1)-2,i) = iec(I(j):I(j+1)-2,i) - iec(I(j)+1:I(j+1)-1,i);
   end
end

