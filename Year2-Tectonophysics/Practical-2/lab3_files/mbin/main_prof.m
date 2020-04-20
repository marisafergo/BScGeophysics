function [sumprof] = main_prof(imfile,profswath,profstep,prec,interleave,gmtfaultfile)
%
%function [prof] = main_prof(imfile,profswath,profstep,prec,interleave,gmtfaultfile)
%  interactively make profile for an image
%
% Inputs:
%   imfile: input image
%   profswath: profile swath (half bin width of the profile, default 1)
%   profstep: profile step (bin length along the profile, default 1)
%   prec:   precision of input file, 1: real4 (default); 2: int16; 3: int8; others: double
%   interleave: the format in which the data is stored (default: 'real'; 'complex'; 'rmg')
%   gmtfaultfile: fault file in gmt format (optional)
%
% Outputs:
%   none
% Jan 29, 2013
%
if nargin<2
  profswath = 1;
end

if nargin<3
  profstep = 1;
end

if nargin<4
  prec=1;
end

if nargin<5
  interleave='real';
end

if nargin<6
  gmtfaultfile=[];
end

%read image rsc file
rscname = char(strcat(imfile,'.rsc'));
ifghdr=rsc2hdr(rscname);

%read image
[indata]= readmat(imfile,ifghdr.length,ifghdr.width,prec,interleave);
nband=size(indata,3);
im=indata(:,:,nband); %assume the last band is used here
clear indata;

%extract profile parameters, and save it to the current directory
profdef=char('profdef.dat');
if ~exist(profdef,'file')
  if ~isempty(gmtfaultfile)
    [fault]=gmt2mat_faults(char(gmtfaultfile));
    plotifg(im,0,'im',0,ifghdr,fault);
  else
    plotifg(im,0,'im',0,ifghdr);
  end
  extractprof(profswath,profstep);
end
[prof]=profdefine(profdef);

%make profile
nprof=length(prof);
for i=1:nprof
  %don't use ifghdr in 'make_prof' if unit = pixel
  %[profile,sumprof]=make_prof(im,prof(i));
  [profile,sumprof]=make_prof(im,prof(i),ifghdr);
  fid = fopen(char(strcat('outprof.',prof(i).id)),'w');
  fprintf(fid,'distance \t mean \t 1-sigma \n');
  fprintf(fid,'%-6.2f %-6.2f %-6.2f \n',sumprof');
  fclose(fid);

  figure;
  plot(sumprof(:,1),sumprof(:,2),'LineWidth',1);hold on
  plot(sumprof(:,1),sumprof(:,2),'rs','MarkerSize',5,'markerEdgeColor','r','MarkerFaceColor','g','LineWidth',1);
end
