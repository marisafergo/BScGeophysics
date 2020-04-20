function [Xs,Ys,Zs,dT,Ts] = read_sp3(sp3file,sv);

% READ_SP3	Reads sp3 file and returns position vectors.
%
%		Input:
%		  sp3 = orbit file name
%		  sv = satellite PRN
%		Output:
%		  Xs, Ys, Zs = position vectors (km) for satellite sv
%		  dT = clock bias in microseconds
%		  Ts = corresponding time in secs of the current day.
%		Usage:
%		  [Xs,Ys,Zs,dT,Ts] = read_sp3(sp3file,sv);

fid = fopen(sp3file,'r');

Xs=[]; Ys=[]; Zs=[]; Ts=[]; dT=[];

while 1
  line = fgetl(fid);
  if ~isstr(line), break, end

  if (line(1)=='*')
    [t] = sscanf(line, '%c %d %d %d %d %d %f');
  end

  if (line(1)=='P')
     [p] = sscanf(line, '%c %d %lf %lf %lf %f');
     if (p(2) == sv)
       Xs = [Xs;p(3)];
       Ys = [Ys;p(4)];
       Zs = [Zs;p(5)];
       dT = [dT;p(6)];
       Ts = [Ts;t(5)*3600+t(6)*60+t(7)];
     end
  end

end

fclose(fid);

