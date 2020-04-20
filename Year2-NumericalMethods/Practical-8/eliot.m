%write  a  MATLAB script  that  takes  any  set  of  experimental  data 
%and uses linear interpolation to estimate the value of f(x) at any 
%x value that lies within the range studied

% written by Eliot Eaton 
% Date 20:11:17

%asks user for file name and reads it in

file = input('please enter file name: ' ,'s');

fid = fopen(file);

data = fscanf(fid,'%f %f', [2, inf]);

fclose(fid);

data = data';

%asks user for X value where f(x) is wanted
Xval = input('please enter corresponding x value: ');

%Finds Max and Min value of X in data coloumb 1

Xmin = min(data(:,1));

Xmax = max(data(:,1));

%checks Xval is inbetween data limits 

while Xval > Xmax || Xval < Xmin
    Xval = input('please enter x value that falls within x limits: ');
end

%checks if Xval is equal to any already known values

for i = 1:length(data)
    if Xval == data(i,1)
       fprintf('X =' ,data(i,1), 'f(x) =', data(i,2))
    end 
end

%loop through the experimental data to determine the pairs of data points
%that bracket the x value

for j = 1:length(data)
    if Xval > data(j,1) && Xval < data(j+1,1)
        Xtop = data(j+1,1);
        Xbot = data(j,1);
        Fxtop = data(j+1,2);
        Fxbot = data(j,2);
    end 
end 

%ratio 

Fxval = Fxbot+(((Xval-Xbot)*(Fxtop-Fxbot))/(Xtop-Xbot));



fprintf(['X = ', num2str(Xval), ' f(x) = ',num2str(Fxval)])