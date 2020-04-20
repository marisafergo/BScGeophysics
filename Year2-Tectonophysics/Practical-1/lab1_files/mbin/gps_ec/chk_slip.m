function iec_slp = chk_slip(iec_new,thresh);

% CHK_SLIP	Checks for cycle slips
%		thres = threshold for slip detection
%
%		iec_slp = chk_slip(iec_new);

% number of satellites
nsat = size(iec_new,2);

% number of observations
nobs = size(iec_new,1);

% initialize output array
iec_slp = zeros(nobs,nsat);

% for each satellite
for i = 1:nsat
   % detect segments
   x = [0 ; iec_new(:,i)./(iec_new(:,i)+eps^2)];
   y = [iec_new(:,i)./(iec_new(:,i)+eps^2) ; 0];
   z = x - y;
   I = find(z);
   % deal with slips
   if (~isempty(I))
      % foreach data segment
      for j = 1:2:length(I)
         % get segment
         seg = iec_new(I(j):I(j+1)-1,i);

         % find slips in time series = difference between successive data > threshold
         x = [0 ; seg];
         y = [seg ; 0];
         z = x - y;
         J = find(z(2:length(z)-1) > thresh | z(2:length(z)-1) < -thresh);

         if (~isempty(J))
            % find amount of slip and correct it
            k = 1;
            for l = 1:length(J)	% for each segment
               if (l < length(J))
                  slip(l) = mean(seg(k:J(l))) - mean(seg(J(l)+1:J(l+1)));
               else
                  slip(l) = mean(seg(k:J(l))) - mean(seg(J(l)+1:length(seg)));
               end
               seg(J(l)+1:length(seg)) = seg(J(l)+1:length(seg)) + slip(l);
               k = J(l)+1;
            end

            % write output array
            iec_slp(I(j):I(j+1)-1,i) = seg;

         end
      end
   end
end

