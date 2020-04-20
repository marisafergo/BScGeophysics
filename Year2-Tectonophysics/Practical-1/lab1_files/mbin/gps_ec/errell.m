function [smaj, smin, azim] = errell(C,p);

% ERRELL	Compute semi-major axis, semi-minor axis, and orientatiion
%		of an error ellipse from a 2 x 2 covariance matrix
%
%		Input:
%		- C = 2 x 2 covariance matrix (deg^2)
%		- p = confidence level (ex: 0.95)
%                     for one-sigma (in 2D) use p=0.39346;
%
%		Output:
%		- smaj = semi-major axis (deg)
%		- smin = semi-minor axis (deg)
%		- azim = azimuth of semi-major axis
%			(degrees clockwise from north)

% in case matrix larger than 2x2
C = C(1:2,1:2);

% compute eigenvectors and eigenvalues
[eigvec,eigval] = eig(C);

% find maj and min
[smaj,i] = max(diag(eigval));
smajvec = eigvec(:,i);
smin = min(diag(eigval));

% compute azimuth of semi-major axis
azim = atan2(smajvec(2),smajvec(1)) * 180/pi;
azim = 90 - azim;

% compute and apply chi2 (dof=2)
chi2 = chi2_cdf_inv(p,2);
smaj = sqrt(chi2*smaj);
smin = sqrt(chi2*smin);
