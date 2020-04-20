function [week, dow, mjd] = gweek(year, doy);

% GWEEK		Computes GPS week and day of week from year
%		and day of year.
%
% [week, dow, mjd] = gweek(year, doy);

mjd010580 = 44243;
jd52 = 34012;
styr = 52;

% first compute mofidied Julian day
year = year - 1900;
nyr = year - styr;
leap = ( nyr + 3 ) / 4;
dd = nyr * 365;
mjd = ( jd52 - 1 ) + dd + leap + doy;
leapy = mod(year,4) + 1;
if (dd < 29 && leapy == 1 && nyr > 0 ) mjd = mjd - 1; end;
mjd = floor(mjd);

% then compute week and dow
mjd_d = (mjd - mjd010580) - 1;
week = floor(mjd_d / 7);
dow = floor(mod(mjd_d,7));

