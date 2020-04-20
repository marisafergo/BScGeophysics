function [fault] = gmt2mat_faults(gmtfile,iplot)
%======================================================
%function [fault] = gmt2mat_faults(gmtfile,iplot)
%
% convert faults data from gmt to faultlab forfault 
%                                                      
% INPUT:                                               
%   gmtfile: faults file in gmt forfault
%   iplot: plot the figure (optional, default 0)
%
% OUTPUT:                                              
%   fault: faults data in matlab forfault                            
%                                                      
% Hua Wang @ Uni Leeds, 23/11/2009                         
%======================================================
if nargin<2
  iplot=0;
end

fid = fopen(gmtfile,'r');
if fid<0
  error([parfile ' can not be opened!']);
end

fault=[];
i=1;
j=0;
while (feof(fid)==0)
  strline = fgetl(fid);
  strtmp = strline(strline~=' ');
  strlen  = length(strtmp);
  if (strlen<0) || (strtmp(1)=='#')
    continue;
  end
  if (strtmp(1)=='>')
    j=j+1;
  else
    [lon,lat]=strread(strline,'%f %f');
    fault(i,:)=[lon,lat,j];
    i=i+1;
  end
end
fclose(fid);

%plot faults
if iplot==1
  figure
  nseg=max(fault(:,3));
  clim=[min(fault(:,1))-1,max(fault(:,1))+1,min(fault(:,2))-1,max(fault(:,2))+1];
  for i=1:nseg
    ifault=fault(fault(:,3)==i,1:2);
    plot(ifault(:,1),ifault(:,2),'b','LineWidth',1);
    hold on
  end
  axis(clim);
end
