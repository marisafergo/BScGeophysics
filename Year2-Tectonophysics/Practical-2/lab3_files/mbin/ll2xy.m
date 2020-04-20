function [x,y] = ll2xy(lon,lat,ifghdr)
% function [x,y] = ll2xy(lon,lat,ifghdr)
%
% Function to calculate pixel coordinates (x,y) from Longitude and
% Latitudes for Juliet/Hua's InSAR analysis code
%
% inputs: lon, lat (vectors)
%         ifghdr (structure)
%
% outputs x,y (vectors)
%
% TJW 21 Nov 09

x  = floor((lon-ifghdr.xfirst)/ifghdr.xstep) + 1;
y = floor((lat-ifghdr.yfirst)/ifghdr.ystep) + 1;
