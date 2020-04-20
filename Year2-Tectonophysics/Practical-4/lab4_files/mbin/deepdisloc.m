function [v] = deepdisloc(x,s,d)
% function [v] = deepdisloc(x,s,d)
% 
% Function to calculate displacements/velocities due to slip on a deep 
% screw dislocation (infinitely long strike slip fault. 
% After Savage and Burford (1973)
%
% v = (s/pi)*arctan(x/d)
%
% INPUTS
% x = vector of distances from fault
% s = slip or slip rate on deep dislocation
% d = locking depth [same units as x]
%
% OUTPUTS
% v = vector of displacements or velocities at locations defined by x
%       [same units as s]
%
% Tim Wright
% 4 March 2013

v = (s/pi)*atan(x/d);
