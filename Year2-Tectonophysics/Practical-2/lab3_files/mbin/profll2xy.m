function [prof] = profll2xy(prof,ifghdr)
%===============================================================
%function [prof] = profll2xy(prof,ifghdr)
%                                                                       
% Function to convert profile coordinates from degree to pixel
%                                                                       
% INPUT:                                                     
%   prof:  structure of profile in degree
%   ifghdr: ifg header (optional)
%
% OUTPUT:
%   prof: structure of profile in pixel
%
% Hua Wang, 20/04/2010
%===============================================================

nprof = length(prof);
for i=1:nprof
  [prof(i).x0, prof(i).y0] = ll2xy(prof(i).x0,prof(i).y0,ifghdr);
  [prof(i).x1, prof(i).y1] = ll2xy(prof(i).x1,prof(i).y1,ifghdr);
end
