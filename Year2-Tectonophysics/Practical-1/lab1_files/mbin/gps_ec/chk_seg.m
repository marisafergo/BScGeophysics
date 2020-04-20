function iec_new = chk_seg(iec);

% CHK_SEG	Checks data segmentation and keep longest segment only
%		iec_new = chk_seg(iec);

% number of satellites and observations
nsat = size(iec,2);
nobs = size(iec,1);

% initialize output array
iec_new = zeros(nobs,nsat);

% for each satellite
for i = 1:nsat
   % detect segments
   x = [0 ; iec(:,i)./(iec(:,i)+eps^2)];
   y = [iec(:,i)./(iec(:,i)+eps^2) ; 0];
   z = x - y;
   I = find(z);
   % compute segment length and find longest
   if (~isempty(I))
      I1 = I(2:length(I));
      I2 = I(1:length(I)-1);
      I0 = I1 - I2;
      I0 = I0(1:2:length(I0));
      [MAX,J] = max(I0);
      jmin = I((J*2)-1);
      jmax = I((J*2))-1; % -1 in case we reach the end
      % write longest segment only in output array
      iec_new(jmin:jmax,i) = iec(jmin:jmax,i);
   end
end

