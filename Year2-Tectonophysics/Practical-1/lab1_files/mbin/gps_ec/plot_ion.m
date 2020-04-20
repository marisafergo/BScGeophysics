function plot_ion(svprn,T,iec,iec_dot)

% PLOT_ION	Plots iec and iec_dot for a given svprn
%		plot_ion(svprn,T,iec,iec_dot)
%		svprn = prn number
%		iec, iec_dot = from get_ion

figure;

subplot(2,1,1);
J=find(iec(:,svprn));
plot(T(J),iec(J,svprn));
title(['IEC for PRN' num2str(svprn)]);
xlabel(['hours']);
ylabel(['IEC (m)']);

subplot(2,1,2);
J=find(iec_dot(:,svprn));
plot(T(J),iec_dot(J,svprn));
title(['IEC DOT for PRN' num2str(svprn)]);
xlabel(['hours']);
ylabel(['IEC_DOT (m)']);
