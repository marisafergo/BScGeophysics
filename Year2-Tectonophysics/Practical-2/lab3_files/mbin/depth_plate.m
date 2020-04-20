function [depth] = depth_plate(t,p)
% function [depth] = depth_plate(t,params_plate)
%
% Function to calculate depth of ocean floor from Parsons and Sclater 1977
% plate cooling model as a function of the age of the plate (t)
%
% INPUTS
%
% t = Nx1 column vector containing ages at which to calculate w [Ma]
% params_hs is structure containing all the parameters required to solve
% for the model:
% params_plate.rhom = density of the mantle [kg m^(-3)]
% params_plate.rhow = density of seawater [kg m^(-3)]
% params_plate.alphav = volumetric coeff. of thermal expansion for mantle [K^-1]
% params_plate.Tm = Temperature of the mantle [K] 
% params_plate.T0 = Temperature of seawater [K]
% [note that it is the difference between Tm and T0 that is important]
% params_plate.kappa = thermal diffusivity [m^2 s^(-1)]
% params_plate.ridge_depth = elevation of ridge [m]  [e.g. -2500]
% params_plate.yL = thickness of old lithosphere [m]
% params_plate.n = number of terms in infinite series to use.
%
% OUTPUTS
%
% w = Nx1 column vector containing depth of water at times t [m]
%
% Tim Wright
% January 2013

%% convert t into SI units [s] from [Ma]
t = t*10^6*365.25*24*60*60;

%% calculate w (depth of ocean floor below ridge)
% constant term
constant = p.yL*p.alphav*p.rhom*(p.Tm-p.T0)/(p.rhom - p.rhow);

% calculate infinite series part, use first p.n terms
series = 0*t;
for k = 0:((p.n)-1)
   series = series + (1/((1+2*k)^2))*exp(-p.kappa*((1+2*k)^2)*(pi^2)*t/(p.yL^2));
end
% calculate depth of ocean
w = constant * (0.5 - (4/(pi^2))*series); %depth below ridge
depth = p.ridge_depth - w;


