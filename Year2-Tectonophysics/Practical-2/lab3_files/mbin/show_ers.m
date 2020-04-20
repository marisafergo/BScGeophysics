function [ermgrid,ncols,nlines,X,Y]=show_ers(ermfile)
%function [ermimage,ncols,nlines]=show_ers(ermfile)
%
% function to read and display an ERMapper format binary file
% [as produced by oksar3]
%
% ermimage = filename (without the .ers extension).
% 
% e.g. usage
% [ermimage,ncols,nlines] = show_ers('ifm1_los')
%
% TJW  11 January 2005

%read text file header
ermhead = sprintf('%s.ers',ermfile)
header = readtextfile(ermhead);

%byte order
     line = findstring(header,'LSBFirst');
     if (line > 0) 
       byte = 'l'
     else
       byte = 'b'
     end

%Binary File Type
     line = findstring(header,'IEEE8ByteReal');
     if (line > 0) 
      ftype  = 'real*8'
     end
     line = findstring(header,'IEEE4ByteReal');
     if (line > 0) 
      ftype  = 'real*4'
     end
     line = findstring(header,'Signed16BitInteger');
     if (line > 0) 
      ftype  = 'int16'
     end
     line = findstring(header,'Unsigned8BitInteger');
     if (line > 0) 
      ftype  = 'int8'
     end
%%%note - need to add more file types. but this works for oksar.


%nlines
     line = findstring(header,'NrOfLines');
     eval(header(line,:))
     nlines = NrOfLines;
  
%ncols
     line = findstring(header,'NrOfCellsPerLine');
     eval(header(line,:))
     ncols = NrOfCellsPerLine;
     
%topleft coord
     line = findstring(header,'Eastings');
     eval(header(line,:))
     TLx = Eastings;
     line = findstring(header,'Northings');
     eval(header(line,:))
     TLy = Northings;

%cellsize
     line = findstring(header,'Xdimension');
     eval(header(line,:))
     xd = Xdimension;
     line = findstring(header,'Ydimension');
     eval(header(line,:))
     yd = Ydimension;

%Calculate coordinates
X = (TLx+xd/2):xd:(TLx-xd/2+ncols*xd); 
Y = (TLy-yd/2):-yd:(TLy+yd/2-nlines*yd); 
     

%%read grid file
in = fopen(ermfile,'r',byte) ; %
ermgrid = fread(in,[ncols,nlines],ftype) ;
fclose(in);
ermgrid=ermgrid'; %transpose grid (it's an image)

%display ermgrid
colormap('default')
imagesc(X,Y,ermgrid);
colorbar('vert');
axis xy
axis image;


