function [wmean,wrms] = get_wrms(v,sv);

% GET_WRMS	Calculate weighted mean and scatter about weighted mean.

n = length(v);

% calculate weights
w = 1./(sv.^2);

% calculate weighted mean
num = sum(v.*w);
sumw = sum(w);
wmean = num/sumw;

% calculate scatter w.r.t. weighted mean
chi2 = sum( ((v-wmean)./sv) .^2 );
wrms = sqrt( (n/(n-1)) * chi2/sumw );

