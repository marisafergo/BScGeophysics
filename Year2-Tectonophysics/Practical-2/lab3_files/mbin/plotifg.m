function[]=plotifg(ifg,nsig,strtitle,print,ifghdr,fault)
%================================================================
%function[]=plotifg(ifg,nsig,strtitle,print,ifghdr,fault)
%                                                                
% Plot one interferogram                              
%                                                                
% INPUT:                                                         
%   ifg: input interferogram                                     
%   nsig: flag for the range of output values                    
%         nsig:  plot within [mean - nsig*sigma, mean + nsig*sigma]  
%         default 0: plot within [min, max]
%   strtitle: title used for the plot (default: no title)        
%   print: 1: print as a file 0: not print (optional, default 0)
%   ifghdr: ifg header (optional)
%   fault: coordinate of faults (optional, (x,y,isegment)
% OUTPUT:                                                        
%   NO                                                           
%                                                                
% Hua Wang @ Uni Leeds, 02/02/2008                                 
%
% 20/04/2010 HW: plot in geographic coordinate
%                set coordinate origin as bottom-left corner
% 21/01/2010 HW: plot fault
%================================================================
opengl software
[rows,cols]=size(ifg);

if nargin<2
  nsig=0;
end
if nargin<4
  print=0;
end

figure

if nsig>0
  %calculate std and mean
  ifgv = reshape(ifg',rows*cols,1);
  ifgv(isnan(ifgv))=[];
  std_ifg=std(ifgv);
  mean_ifg=mean(ifgv);
  clims = [mean_ifg-nsig*std_ifg mean_ifg+nsig*std_ifg];
else
  clims = [min(min(ifg)) max(max(ifg))];
end

if nargin>4
  x=[ifghdr.xfirst,ifghdr.xfirst+(cols-1)*ifghdr.xstep];
  y=[ifghdr.yfirst,ifghdr.yfirst+(rows-1)*ifghdr.ystep];
else
  x=[1,cols];
  y=[rows,1];
end

imagesc(x,y,ifg,clims)
set(gca,'YDir','normal')
colormap(jet);
colorbar;
axis equal;
axis image;
%set(gca,'xtick',[],'xticklabel',[])
%set(gca,'ytick',[],'yticklabel',[])
if nargin>=3
  title(strtitle);
end

%Now set the alpha map for the NaN region
z=double(~isnan(ifg));
alpha(z);
set(gca, 'color', [0.5 0.5 0.5]);
hold on

if nargin>5
  nseg=max(fault(:,3));
  for i=1:nseg
    ifault=fault(fault(:,3)==i,1:2);
    plot(ifault(:,1),ifault(:,2),'k','LineWidth',1);
    hold on
  end
end

%if print==1
%  print('-djpeg','-r300',num2str(strtitle));
%end
