function [eph,alpha,beta] = read_rinexn(rinexn)

% READ_RINEXN	Reads a rinex navigation file.
%
%              Input:
%   	           rinexn  = rinex navigation file name
%              Output:
%                eph = matrix with 21 rows and as many columns
%                      as there are ephemerides.
%                alpha = ionospheric coefficients (4 element vector)
%                beta  = ionospheric coefficients (4 element vector)
%
%              Usage:
%	              eph = read_rinexn(rinexn)

fid = fopen(rinexn);

% read header
alpha = [];
beta = [];
line = fgetl(fid);
while ~(strcmp(line(61:63),'END'))
   line = fgetl(fid);
   if (strcmp(line(61:69),'ION ALPHA'))
     alpha = [str2num(line(4:14)) str2num(line(16:26)) str2num(line(28:38)) str2num(line(40:50))];
   end
   if (strcmp(line(61:68),'ION BETA'))
     beta = [str2num(line(4:14)) str2num(line(16:26)) str2num(line(28:38)) str2num(line(40:50))];
   end
end

% read body
j = 1;
while 1
   line = fgetl(fid);
   if ~isstr(line), break, end
   tmp = sscanf(line, '%d %d %d %d %d %d %f');
   svprn = tmp(1);
   toc = tmp(5) + tmp(6)/60 + tmp(7)/3600;
   clock_bias = str2num(line(23:41));
   clock_drift = str2num(line(42:60));
   clock_drift_rate = str2num(line(61:79));

   line = fgetl(fid);
   iode = str2num(line(4:22));
   crs = str2num(line(23:41));
   sv_health = str2num(line(23:41));
   deltan = str2num(line(42:60));
   M0 = str2num(line(61:79));

   line = fgetl(fid);
   cuc = str2num(line(4:22));
   ecc = str2num(line(23:41));
   cus = str2num(line(42:60));
   roota = str2num(line(61:79));

   line = fgetl(fid);
   toe = str2num(line(4:22));
   cic = str2num(line(23:41));
   Omega0 = str2num(line(42:60));
   cis = str2num(line(61:79));

   line = fgetl(fid);
   i0 = str2num(line(4:22));
   crc = str2num(line(23:41));
   omega = str2num(line(42:60));
   Omegadot = str2num(line(61:79));

   line = fgetl(fid);
   idot = str2num(line(4:22));
   codesL2 = str2num(line(23:41));
   gpsweek = str2num(line(42:60));
   L2Pflag = str2num(line(61:79));

   line = fgetl(fid);
   sv_accuracy = str2num(line(4:22));
   sv_health = str2num(line(23:41));
   tgd = str2num(line(42:60));
   iodc = str2num(line(61:79));

   line = fgetl(fid);

   eph(1,j) = svprn;
   eph(2,j) = clock_drift_rate;
   eph(3,j) = M0;
   eph(4,j) = roota;
   eph(5,j) = deltan;
   eph(6,j) = ecc;
   eph(7,j) = omega;
   eph(8,j) = cuc;
   eph(9,j) = cus;
   eph(10,j) = crc;
   eph(11,j) = crs;
   eph(12,j) = i0;
   eph(13,j) = idot;
   eph(14,j) = cic;
   eph(15,j) = cis;
   eph(16,j) = Omega0;
   eph(17,j) = Omegadot;
   eph(18,j) = toe;
   eph(19,j) = clock_bias;
   eph(20,j) = clock_drift;
   eph(21,j) = toc;
   j=j+1;
end

fclose(fid);

