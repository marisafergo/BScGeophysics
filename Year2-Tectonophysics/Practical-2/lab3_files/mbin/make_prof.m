function [profile,sumprof] = make_prof(ifg,prof,ifghdr,stdifg,alpha)
%=======================================================================
%function [profile,sumprof] = make_prof(ifg,prof,ifghdr,stdifg,alpha)
%                                                                       
% Function to get values along a giving profile                        
%                                                                       
% INPUT:
%   ifg:  input interferogram
%   prof: structure of profile (x0,y0,x1,y1,swath,step)
%   ifghdr: ifg header
%   stdifg: error map (std) of the input interferogram    (optional)
%   alpha:  e-folding lenght for atmospheric delay errors (optional)
% OUTPUT:                                                               
%   profile: all datapoint along the profile                            
%   sumprof: profile after averaging the datapoints within a swath*step  
%                                                                       
% Hua Wang @ Uni Leeds, 04/03/2008                                      
%
% 04/11/2010 HW: update pixel size according to the profile coordinate
% 20/04/2010 HW: support lon/lat as the unit of profile coordinates
% 09/09/2009 HW: change input argument from psize to xpsize and ypsize
% 27/08/2009 HW: using structure for prof
%=======================================================================

[rows,cols]=size(ifg);
n=rows*cols;

%default parameters
if nargin<4
  stdifg = ones(rows,cols); %independent, and equal weight
end

if nargin<3
  ifghdr=[];
end

if isempty(ifghdr)
  xpsize=1;
  ypsize=1;
else
  %update pixel size for the profile because ifghdr.x/ypsize from larger area are not precise enough
  %updated 04/11/2010, HW
  dx=llh2local([prof.x1;(prof.y0+prof.y1)/2],[prof.x0;(prof.y0+prof.y1)/2]);
  dx=norm(dx);
  dy=llh2local([(prof.x0+prof.x1)/2;prof.y1],[(prof.x0+prof.x1)/2;prof.y0]);
  dy=norm(dy);

  %convert from lon/lat to pixel coordinate x/y
  [prof] = profll2xy(prof,ifghdr);

  %updated 04/11/2010, HW
  xpsize=abs(dx/(prof.x1-prof.x0));
  ypsize=abs(dy/(prof.y1-prof.y0));
  clear('dx','dy');
end

%get the transform matrix
%[ cos(alpha)  sin(alpha) ]
%[-sin(alpha)  cos(alpha) ]
sx = (prof.x1-prof.x0)*xpsize;  %x coordinate
sy = (prof.y1-prof.y0)*ypsize;  %y coordinate
l = sqrt(sx*sx+sy*sy);
coef = [sx/l, sy/l; -sy/l, sx/l];

%coordinate transform
[yy,xx]=meshgrid(1:rows,1:cols);
xxv=reshape(xx,n,1);
yyv=reshape(yy,n,1);
grid=[(xxv-prof.x0)*xpsize, (yyv-prof.y0)*ypsize]; %convert to km
grid=grid';
outgrid = coef*grid;
outgrid = outgrid';
clear('xxv','yyv','xx','yy','grid');

%dataset including outgrid,ifg,stdifg
ifgv=reshape(ifg',n,1);
stdv=reshape(stdifg',n,1);

%profile(:,1): distance along the profile
%profile(:,2): distance normal to the profile
%profile(:,3): ifg
%profile(:,4): std of ifg
%remove pixels outside of swath and NAN
%swath:  swath width in km                                           
profile=[outgrid,ifgv,stdv];
profile(isnan(profile(:,3)),:)=[];
profile=profile(find(profile(:,1)>0 & profile(:,1)<l & abs(profile(:,2))<prof.swath),:);
if size(profile,1)==0
  error('No points left within the profile swath')
end

clear('ifg','stdifg','ifgv','stdv','outgrid');

%step: bin width in km
k=1;
smin = floor(min(profile(:,1)));   %minimum distance along the profile
smax = floor(max(profile(:,1)));   %maximum distance along the profile
for ibin=smin:prof.step:smax-prof.step
  %get data within a bin
  bin=profile(find(profile(:,1)>=ibin & profile(:,1)<(ibin+prof.step)),:); 
  npix = size(bin,1);
  if npix>=1
    %variance-covariance matrix
    if nargin>3
      xdistdiff=repmat(bin(:,1),1,npix)-repmat(bin(:,1)',npix,1);
      ydistdiff=repmat(bin(:,2),1,npix)-repmat(bin(:,2)',npix,1);
      dist=sqrt(xdistdiff.^2+ydistdiff.^2);
      vcm=exp(-dist.*alpha);        %spatial correlation
      vcm_tmp = bin(:,4)*bin(:,4)';
      vcm = vcm_tmp.*vcm;
    else
      vcm=diag(bin(:,4));           %no spatial correlation
    end
    %ls inversion
    B = ones(npix,1);         %design matrix
    [x,stdx,mse]=lscov(B,bin(:,3),vcm);
    stdx=stdx./sqrt(mse);  %HW: 27/03/2012
    %output profile matrix
    distprof=mean(bin(:,1));
    sumprof(k,:)=[distprof,x,stdx];
    k=k+1;
  end
end
