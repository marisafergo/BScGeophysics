function [mp1,mp2,t,sv] = get_mp(rinex_file);

% GET_MP	Computes mp1 and mp2 multipath noise. Use plot_mp to plot.
%
%		input:
%         rinex file name, file is read with readrinex
%     output:
%         mp1, mp2 = output multipath matrices with one
%		               satellite per column and epochs in the row direction.
%                    units = meters
%         t = time vector (decimal hours)
%         sv = list of prns
%     Usage:
%         [mp1,mp2,t,sv] = get_mp(rinex_file);

% set maximum offset threshold
max_off = 10;

% read rinex file
[Observables,epochs,sv,apcoords]=readrinex(rinex_file);

% extract observables
L1 = Observables.L1;
L2 = Observables.L2;
C1 = Observables.C1;
P1 = Observables.P1;
P2 = Observables.P2;

% do we have P1 observable?
if (isempty(find(~isnan(P1))))
  disp(['WARNING: no P1 data, using C1 instead']);
  P1 = C1;
end

% compute time vector
t = epochs(:,4) + epochs(:,5)/60 + epochs(:,6)/3600;

% L1 and L2 frequencies
f1 = 1.57542e9;
f2 = 1.2276e9;
c = 0.299792458e9;
l1 = c/f1;
l2 = c/f2;

% alpha "ionospheric" coefficient
a = (f1/f2)^2;

% convert phase observations to meters
L1m = L1 .* l1;
L2m = L2 .* l2;

% compute MP1 and MP2
ION1 = L1m .* ((2/(a-1))+1) + L2m .* (2/(a-1));
MP1 = P1 - L1m .* ((2/(a-1))+1) + L2m .* (2/(a-1));
MP2 = P2 - L1m .* ((2*a)/(a-1)) + L2m .* (((2*a)/(a-1))-1);

% replace NaN by zeros
I = find(isnan(MP1)); MP1(I) = 0;
I = find(isnan(MP2)); MP2(I) = 0;

% initialize mp1 mp2 matrices
mp1 = zeros(length(t),length(sv));
mp2 = zeros(length(t),length(sv));

% find data segments, compute mean, and remove from mp values
% for each satellite
for i = 1:length(sv)
   x = [0 ;  MP1(:,i)./(MP1(:,i)+eps)];
   y = [MP1(:,i)./(MP1(:,i)+eps) ; 0];
   z = x - y;
   I = find(z);
   % for each data segment
   for j = 1:2:length(I)
      % check for large offsets in MP1
      mp = [MP1(I(j):I(j+1)-1,i)];
      dmp = diff(mp);
      J = find(abs(dmp) > max_off);
      if (~isempty(J))
        disp(['Large MP1 offset found for PRN ' num2str(sv(i))]);
        for k = 1:length(J)
          mp(J(k)+1:end) = mp(J(k)+1:end) - dmp(J(k));
        end
        MP1(I(j):I(j+1)-1,i) = mp;
      end
      % check for large offsets in MP2
      mp = [MP2(I(j):I(j+1)-1,i)];
      dmp = diff(mp);
      J = find(abs(dmp) > max_off);
      if (~isempty(J))
        disp(['Large MP2 offset found for PRN ' num2str(sv(i))]);
        for k = 1:length(J)
          mp(J(k)+1:end) = mp(J(k)+1:end) - dmp(J(k));
        end
        MP2(I(j):I(j+1)-1,i) = mp;
      end
      % compute and remove mean
      mean_MP1 = mean(MP1(I(j):I(j+1)-1,i));
      mp1(I(j):I(j+1)-1,i) = MP1(I(j):I(j+1)-1,i) - mean_MP1;
      mean_MP2 = mean(MP2(I(j):I(j+1)-1,i));
      mp2(I(j):I(j+1)-1,i) = MP2(I(j):I(j+1)-1,i) - mean_MP2;
   end
end

