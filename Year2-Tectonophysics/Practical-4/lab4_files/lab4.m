% LAB 4
% Viscoelastic Coupling Model of the Earthquake Cycle: The North Anatolian 
% Fault


% ______________________________________________________________
%|                   Marisabel Gonzalez                         
%|                       15/03/2018                             
%|______________________________________________________________

% These commands clear the command window, the workspace, all existent 
% images and variables
clc
clear all
close all
clearvars

% ----------------------------------------------------------------------
%                         NOMENCLATURE                          
% ----------------------------------------------------------------------
%   d: locking depth [km]
%   d_min: minimum locking depth
%   in: input values required to use the savage2000 function
%   indexmin: contains the indices of the minimum values in rms
%   interseis: interseismic data
%   postseis: postseismic data
%   res: residual velocities
%   rms_i: rms of interseismic data
%   rms_min: minimum rms
%   rms_p: rms of postseismic data
%   s: slip or slip rate on deep dislocation [mm/yr]
%   strmin: string of minima
%   Tr: relaxation time [yr]
%   Tr_min: minimum relaxation time
%   v1_i: velocities predicted by model for interseismic data
%   v2_i: velocities predicted by model for interseismic data
%   v3_i: velocities predicted by the savage function for interseismic data
%   v3_p: velocities predicted by the savage function for postseismic data
%   x: vector of distances from fault [km]
%   x_inter: distance from fault in km for interseismic data
%   x_post: distance from fault in km for postseismic data



% Adding mbin to the path
addpath mbin

% Loading the interseismic and postseismic velocities
load interseis.dat
load postseis.dat


% ********************************************************************
%                         Interseismic Data
% ********************************************************************

%---------------------------------------------------------------------
%  TASK 1: Finding the best fitting elastic dislocation mode for 
%          interseismic GPS data acquire prior to the 1999 earthquakes      
%---------------------------------------------------------------------



% Creating a vector of positions
x = [-100:1:100]';                     % in km
                                      
s = 24;                                % (given value) [mm/yr]


% --------------------------------------------------------------------
% Finding the locking depth that minimises the residual misfit between
% the observed and model interseismic velocities
% --------------------------------------------------------------------


% This loop calculates the residual for multiple values of locking depth,d
    
for d = [1:50]
     
   x_inter = interseis(:,1);                    % x in interseisismic data
       
   % Creating a vector of residuals
   [v1_i] = deepdisloc(x_inter,s,d);            % calling the function

   res =  interseis(:,2) - v1_i(:,1);

   % Calculating the root mean square misfit
   rms_i(d) = norm(res);

end

d = [1:50];

% These commands find the indices of the minimum values 
% in rms and uses the indices to find the minimum points
indexmin = find(min(rms_i)==rms_i);
d_min = d(indexmin);
rms_min = rms_i(indexmin);

% Plotting the values
hold on 
plot(d,rms_i,'-','Marker','square','MarkerFaceColor', 'red', ...
    'MarkerIndices', d_min);

% Adding string to graph
strmin = ['locking depth at min = ' num2str(d_min)];
text(d_min,rms_min,strmin,'VerticalAlignment', 'Cap');

% Adding title and axis labels         
title('RMS vs Locking depth') 
xlabel('Locking depth [km]')
ylabel('rms misfit [mm/yr]')



% Plotting the interseismic velocities
figure
errorbar(interseis(:,1),interseis(:,2),interseis(:,3), '.');


d = 22;  % predicted locking depth
                                     

% Calculating the model predictions by calling the function deepdisloc
[v2_i] = deepdisloc(x,s,d);                                     
                                     
% Plotting the model predictions
hold on 
plot(x,v2_i, '-','linewidth',2);

% Adding title and axis labels         
title('Model predictions') 
xlabel('Distances from fault [km]')
ylabel('Velocity at x [mm/yr]')
legend('Real interseismic data','Locking depth prediction','Location' ...
    ,'northwest' )


%---------------------------------------------------------------------
%  TASK 2: Determining the parameters of the viscoelastic coupling
%          model that best match the observed interseismic deformation
%          late in the cycle
%---------------------------------------------------------------------


% This loop calculates the residual for multiple values relaxation time,
% Tr

for Tr = [1:5000]

   in=[24,195,200,Tr,22,22];                        % array containing
                                                    % input values
   x_inter = interseis(:,1);
   
   [v3_i] =  savage2000(x_inter',in);               % calling the function

   res = interseis(:,2) - v3_i';

   % Calculating the root mean square misfit
   rms_i(Tr) = norm(res);
   
end

Tr = [1:5000];

% These commands find the indices of the minimum values 
% in rms and uses the indices to find the minimum points
indexmin = find(min(rms_i)==rms_i);
Tr_min = Tr(indexmin);
rms_min = rms_i(indexmin);

% Plotting the values
figure
hold on 
plot(Tr,rms_i,'-','Marker','square','MarkerFaceColor', 'red', ...
    'MarkerIndices', Tr_min);

% Adding string to graph
strmin = ['Tr at max = ', num2str(Tr_min)];
text(Tr_min,rms_min,strmin,'VerticalAlignment', 'Cap');


% Adding title and axis labels       
title('RMS vs Maxwell relaxation time') 
xlabel('Relaxation time [years]')
ylabel('rms misfit [mm/yr]')

%-------------------------------------------------------------------------
% Relationship between best relaxation time (Tr), model and real data
%-------------------------------------------------------------------------

% Plotting the interseismic velocities
figure
hold on
errorbar(interseis(:,1),interseis(:,2),interseis(:,3), '.');


  x_inter = interseis(:,1);                     % x in interseismic data
  
  x_inter = sort(x_inter);                      % sorting values in
                                                % ascendent order 

% Plotting the relaxation time
in=[24,195,200,3237,22,22];                     % input values
[v3_i] =  savage2000(x_inter',in);              % calling the function
hold on 
plot(x_inter,v3_i,'-','linewidth',2);

% Plotting the model predictions
hold on 
plot(x,v2_i,'--','linewidth',2);

% Adding title, axis labels and legend      
title('Parallel Velocity vs Distance from fault') 
xlabel('Distance from fault [km]')
ylabel('Fault-parallel velocity [mm/yr]')    
legend('Real interseismic data','Relaxation time','Model','Location' ...
    ,'northwest' )




% ********************************************************************
%                          Postseismic Data
% ********************************************************************
                                            
%---------------------------------------------------------------------
%  Task 3: Determining the parameters of the viscoelastic coupling 
%          model that best match the observed postseismic deformation  
%          early in the cycle. 
%---------------------------------------------------------------------


% This loop calculates the residual for multiple values relaxation time,
% Tr

for Tr = [1:200]

   in=[24,0.5,200,Tr,22,22];                      % array containing
                                                  % input values
                                                  
   x_post = postseis(:,1);                        % x in interseismic data
   
   [v3_p] =  savage2000(x_post',in);              % calling the function

   res = postseis(:,2) - v3_p';

   % Calculating the root mean square misfit
   rms_p(Tr) = norm(res);
   
end

Tr = [1:200];

% These commands find the indices of the minimum values 
% in rms and uses the indices to find the minimum points
indexmin = find(min(rms_p)==rms_p);
Tr_min = Tr(indexmin);
rms_min = rms_p(indexmin);

% Plotting the values
figure
hold on 
plot(Tr,rms_p,'-','Marker','square','MarkerFaceColor', 'red', ...
    'MarkerIndices', Tr_min);

% Adding string to graph
strmin = ['Tr at min = ', num2str(Tr_min)];
text(Tr_min,rms_min,strmin,'VerticalAlignment', 'Cap');

% Adding title and axis labels       
title('RMS vs Maxwell relaxation time') 
xlabel('Relaxation time [years]')
ylabel('rms misfit [mm/yr]')

%-------------------------------------------------------------------------
% Relationship between best relaxation time (Tr), model and real data
%-------------------------------------------------------------------------

% Plotting the postseismic velocities
figure
hold on
errorbar(postseis(:,1),postseis(:,2),postseis(:,3), '.');


  x_post = postseis(:,1);                     % x in interseismic data
  
  x_post = sort(x_post);                      % sorting values in
                                              % ascendent order 

% Plotting the relaxation time
in=[24,0.5,200,17,22,22];                     % input values
[v3_p] =  savage2000(x_post',in);             % calling the function
hold on 
plot(x_post,v3_p,'-','linewidth',2);

% Adding title, axis labels and legend      
title('Parallel velocity vs Distance from fault') 
xlabel('Distance from fault [km]')
ylabel('Fault-parallel velocity [mm/yr]')    
legend('Real postseismic data','Relaxation time','Location' ...
    ,'northwest' )


% ********************************************************************
%                  Interseismic and Postseismic Data
% ********************************************************************

% Plotting the interseismic velocities
figure
hold on
errorbar(interseis(:,1),interseis(:,2),interseis(:,3), '.');


  x_inter = interseis(:,1);                   % x in interseismic data
  
  x_inter = sort(x_inter);                    % sorting values in
                                              % ascendent order 

% Plotting the relaxation time
in=[24,195,200,3237,22,22];                   % input values
[v3_i] =  savage2000(x_inter',in);            % calling the function
hold on 
plot(x_inter,v3_i,'-','linewidth',2);

% Plotting the model predictions
hold on 
plot(x,v2_i,'--','linewidth',2);

% Plotting the postseismic velocities
hold on
errorbar(postseis(:,1),postseis(:,2),postseis(:,3), '.');


% Plotting the relaxation time
in=[24,0.5,200,17,22,22];                     % input values
[v3_p] =  savage2000(x_post',in);             % calling the function
hold on 
plot(x_post,v3_p,'-','linewidth',2);


% Adding title, axis labels and legend      
title('Parallel velocity vs Distance from fault') 
xlabel('Distance from fault [km]')
ylabel('Fault-parallel velocity [mm/yr]')    
legend('Real interseismic data','Interseismic relaxation time'...
,'Model','Real posteismic data','Postseismic relaxation time' ...
,'Location','northwest' )


%---------------------------------------------------------------------
%                                EXTRA
%---------------------------------------------------------------------

% Plotting postseismic velocities as a function of time
Tr = [1:23];
figure
hold on
loglog(Tr,v3_p,'linewidth',2);

% Adding title and axis labels     
title('Postseismic velocities as a function of time') 
xlabel('Time [years]')
ylabel('Fault-parallel velocity [mm/yr]')    


% 
% ---------------------------------------------------------------------
%                                 END
% ---------------------------------------------------------------------