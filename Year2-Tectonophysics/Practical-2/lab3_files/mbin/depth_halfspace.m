function [depth] = depth_halfspace(t,p)
% function [depth] = depth_halfspace(t,params_hs)
%
% Function to calculate depth of ocean floor from 
% half-space cooling model as a function of the age of the plate (t)
%
% INPUTS
%
% t = Nx1 column vector containing ages at which to calculate w [Ma]
% params_hs is structure containing all the parameters required to solve
% for the model:
% params_hs.rhom = density of the mantle [kg m^(-3)]
% params_hs.rhow = density of seawater [kg m^(-3)]
% params_hs.alphav = volumetric coeff. of thermal expansion for mantle [K^-1]
% params_hs.Tm = Temperature of the mantle [K] 
% params_hs.T0 = Temperature of seawater [K]
% [note that it is the difference between Tm and T0 that is important]
% params_hs.kappa = thermal diffusivity [m^2 s^(-1)]
% params_hs.ridge_depth = elevation of ridge [m]  [e.g. -2000]
% OUTPUTS
%
% w = Nx1 column vector containing depth of water at times t [m]
%
% Tim Wright
% January 2013

%% convert t into SI units [s] from [Ma]
t = t*10^6*365.25*24*60*60;

%% calculate w (depth of ocean floor below ridge)

w = 2*p.rhom*p.alphav*(p.Tm-p.T0)*sqrt(p.kappa*t/pi)/(p.rhom - p.rhow);

%% calculate depth of ocean

depth = p.ridge_depth - w;



