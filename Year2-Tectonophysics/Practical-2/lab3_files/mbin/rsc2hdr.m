function [ifghdr] = rsc2hdr(rscfile)
%==============================================
%function [ifghdr] = rsc2hdr(rscfile)
%                                                                   
% Make hdr matrix from a ROI_PAC rsc file
%
% INPUT:
%   rscfile: roi_pac rsc file
%
% OUTPUT:
%   ifghdr: header parameters
%
% Hua Wang, 20/04/2010
%==============================================

%import parameters in the resource file for each data
%only compatible for roi_pac format
%X_FIRST: topleft east
%Y_FIRST: topleft north
[rscmat] = readparfile(rscfile);
ifghdr.width  = getpar('WIDTH',rscmat,'n');
ifghdr.length = getpar('FILE_LENGTH',rscmat,'n');
ifghdr.xfirst = getpar('X_FIRST',rscmat,'n'); 
ifghdr.xstep  = getpar('X_STEP',rscmat,'n');
ifghdr.yfirst = getpar('Y_FIRST',rscmat,'n');
ifghdr.ystep  = getpar('Y_STEP',rscmat,'n');
xlast  = ifghdr.xfirst + (ifghdr.width-1)*ifghdr.xstep;
ylast  = ifghdr.yfirst + (ifghdr.length-1)*ifghdr.ystep;

%calculate approximate pixel size using utm projection, 09/09/2009, HW
origin=[ifghdr.xfirst;ylast];   %bottom-left corner
llh=[xlast;ifghdr.yfirst];      %top-right corner
xy=llh2local(llh,origin);
ifghdr.xpsize=abs(xy(1))/(ifghdr.width-1);
ifghdr.ypsize=abs(xy(2))/(ifghdr.length-1);
