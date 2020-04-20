function plot_mp(prn,mp1,mp2,t,sv)

% PLOT_MP	Plots mp1 and mp2 for a given satellite.
%
%	prn = prn number for satellite to plot
%	mp1, mp2 = MP1 and MP2 matrices (from get_mp)
%       t = time vector (decimal hours) (from get_mp)
%       sv = list of prns (from get_mp)
%
%       usage:  plot_mp(prn,mp1,mp2,t,sv)

% find correct PRN
col = find(sv == prn);
if (isempty(col))
  error(['ERROR: no data for prn ' num2str(prn)]);
end

figure;
subplot(2,1,1);
J=find(mp1(:,col));
plot(t(J),mp1(J,col),'-');
title(['MP1 for PRN' num2str(prn)]);
xlabel(['hours']);
ylabel(['MP1 (m)']);

subplot(2,1,2);
J=find(mp2(:,col));
plot(t(J),mp2(J,col),'-');
title(['MP2 for PRN' num2str(prn)]);
xlabel(['hours']);
ylabel(['MP2 (m)']);

