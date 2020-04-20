function fp = screw2d(x, xf, d, sdot)
%function fp = screw2d(x, xf, d, sdot)
%
%Computes fault-parallel slip rate for 2D screw dislocation
%with fault located at xf, with locking depth d and slip rate sdot.
%Will compute at one or many locations x.
%
%x column vector
%xf scalar
%d scalar
%sdot scalar
%
if ( d == 0 )
   fp = sdot*0.5*sign(x-xf*ones(size(x)));
else
   fp = sdot*atan2((x-xf*ones(size(x))),d)/pi;
end
