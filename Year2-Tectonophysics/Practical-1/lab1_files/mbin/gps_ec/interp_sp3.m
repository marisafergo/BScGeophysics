function [SAT,sv] = interp_sp3(sp3file, splint);

% INT_SP3  Read sp3 file and interpolate satellite positions for
%          given regular time step.
%
%     Input:
%       sp3file = orbit file (sp3 format)
%       splint = interpolation time step (in seconds)
%		
%     Output:
%       SAT = structure with for each field (= PRN) at every splint second;
%             T = time (in hours of the day)
%             X,Y,Z (in meters) for each field (= PRN),
%             dT = satellite clock (in seconds)
%       sv = list of PRN numbers present in sp3 file (vector)
%		
%     Usage: [SAT,sv] = interp_sp3(sp3file, splint);

% Earth's mean radius (meters)
R = 6378137;

% message
disp(['Interpolating orbit file ' sp3file ' every ' num2str(splint) ' seconds']);

% initialize SAT structure
SAT = [];

% get list of prns from sp3 header
fid = fopen(sp3file,'r');
line = fgetl(fid); line = fgetl(fid);
line = fgetl(fid);
n_sv = sscanf(line(2:length(line)),'%d',1);
deli = line(10);
[sv1] = strread(line(11:length(line)),'%f','delimiter',deli);
sv = sv1(find(sv1));
line = fgetl(fid);
[sv2] = strread(line(11:length(line)),'%f','delimiter',deli);
sv = [sv;sv2(find(sv2))];
fclose(fid);

% for each satellite
for i = 1:length(sv)

   % read sp3 file for satellite sv
   [Xs,Ys,Zs,dT,Ts] = read_sp3(sp3file,sv(i));

   if (~isempty(find(Xs)))
      % convert sp3 to meters
      Xs = Xs.*1000;
      Ys = Ys.*1000;
      Zs = Zs.*1000;

      % interpolate
      Ti = 0:splint:24*3600;
      Xi = interp1(Ts,Xs,Ti,'spline');
      Yi = interp1(Ts,Ys,Ti,'spline');
      Zi = interp1(Ts,Zs,Ti,'spline');
      dTi = interp1(Ts,dT,Ti,'spline');

      % convert time to hours
      Ti = Ti / 3600;

      % convert sat clock bias to seconds
      dTi = dTi * 1e-6;

      % fill out SAT structure
      sat_tmp = [Ti;Xi;Yi;Zi;dTi];
      field = ['PRN' num2str(sv(i))];
      SAT = setfield(SAT,field,sat_tmp);
   end

end
