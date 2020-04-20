% These commands clear the comand window, the workspace, all existent 
% images and variables
clc
clear all
close all
clearvars

% Adding mbin to the path
addpath mbin

% Loading the interseismic and postseismic velocities
load interseis.dat
load postseis.dat

% This loop calculates the residual for multiple values relaxation time,
% Tr

x = [-100:1:100]';                     % in km

for Tr = [1:2000]

   in=[24,200.05,200,Tr,22,22];                      % array containing
                                                  % input values
                                                  
   x_post = postseis(:,1);                        % x in interseismic data
   
   [v3_p] =  savage2000(x_post',in);              % calling the function

   res = postseis(:,2) - v3_p(:,1);

   % Calculating the root mean square misfit
   rms_p(Tr) = norm(res);
   
end

Tr = [1:2000];

% These commands find the indices of the minimum values 
% in rms and uses the indices to find the minimum points
indexmin = find(min(rms_p)==rms_p);
Tr_min = Tr(indexmin);
rms_min = rms_p(indexmin);

% Plotting the values
figure
hold on 
loglog(norm(Tr),rms_p,'-','Marker','square','MarkerFaceColor', 'red', ...
    'MarkerIndices', Tr_min);

% Adding string to graph
strmin = ['Tr at min = ', num2str(Tr_min)];
text(Tr_min,rms_min,strmin,'VerticalAlignment', 'Cap');

% Adding title and axis labels       
title('RMS vs Maxwell relaxation time') 
xlabel('Relaxation time [years]')
ylabel('rms misfit [least squares]')

%-------------------------------------------------------------------------
% Relationship between best relaxation time (Tr), model and real data
%-------------------------------------------------------------------------

% Plotting the postseismic velocities
figure
hold on

errorbar(postseis(:,1),postseis(:,2),postseis(:,3), '.');

set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')

  x_post = postseis(:,1);                     % x in interseismic data
  
  x_post = sort(x_post);                      % sorting values in
                                              % ascendent order 

% Plotting the relaxation time
in=[24,200.05,200,65,22,22];                  % input values
[v3_p] =  savage2000(x_post',in);             % calling the function
hold on 
loglog(norm(x_post),norm(v3_p),'-','linewidth',2);

% % Plotting the model predictions
% hold on 
% loglog(x,v2_i,'--','linewidth',2);

% Adding title, axis labels and legend      
title('Parallel velocity vs Distance from fault') 
xlabel('Distance from fault [km]')
ylabel('Fault-parallel velocity [mm/yr]')    
legend('Real postseismic data','Relaxation time','Location' ...
    ,'northwest' )