% Matlab script to plot a circle from 
% the parametric equation


% ______________________________________________________________
%|                   Marisabel Gonzalez                         |
%|                       03/03/2017                             |
%|______________________________________________________________|


% ______________________________________________________________
%                          VARIABLE NOMENCLATURE               |
%    r = radius cm)                                            |
%    t = parameter (from 0 to 2*pi (rad)                       |
%_______________________________________________________________


disp ('PLOTTING A CIRCLE FROM THE PARAMETER EQUATION')
disp (' ')

% USER PROVIDES DE VALUE OF THE RAIDUS r AND PARAMETER t
r = input('Please input the value of the radius (in m): ');
disp (' ') %Blank line

t = linspace(0,2*pi);

% USING THE PARAMETRIC EQUATION 
x=r*cos(t);
y=r*sin(t);


% COMMAND TO PLOT A CIRCLE
plot(x,y)

% COMMAND TO ENSURE THAT THE CIRCLE IS PLOTTED AS A CIRCLE AND NOT
% AS AN ELLIPSE
axis('equal')


