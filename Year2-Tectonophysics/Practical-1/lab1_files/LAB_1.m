% LAB 1: USING GPS TO DETERMINE PLATE MOTIONS AND TO TEST THE RIGIDITY
% OF CONTINENTAL PLATES


% Clearing the workspace,the command window and any existing figure
clear all
%clc
clf


% ______________________________________________________________
%|                   Marisabel Gonzalez                         |
%|                       01/02/2018                             |
%|______________________________________________________________|

% write a display command telling user what the script does

% ______________________________________________________________
%|                         NOMENCLATURE                          
%|______________________________________________________________

% coast: variable contaning the data from file coast.mat
% lo: longitude of GPS site; la = latitude
% ve: velocity in easterly direction [mm/yr]; 
% vn: velocity in northerly direction [mm/yr]
% sve: 1 sigma standard deviation on east velocity; 
% svn: 1 sigma standard deviation on north velocity
% cne: Correlation between sve and svn
% site: site name (4 letter code)
% OM: is the rotation vector (deg/Myr)
% COM: is the variance-covariance matrix for OM
% E is Euler pole and EL is the associated error ellipse for it



% ADDING A DIRECTORY TO SEARCH A PATH
addpath mbin/gps_ec mbin/stats


% LOADING A COASTLINE FILE AND MAKING A BASEMAP FOR AFRICA
load('data/coast.mat');


% PLOTTING AND ZOOMING IN ON AFRICA



figure(1)
plot(long,lat,'g','linewidth',2) % the file aready contain the information
                                 % of these variables, for this reason 
                                 % they haven't been defined within the scrip

                    
axis equal  % this command sets the aspect ratio so that the data 
            % units are the same in every direction
            

axis([-30 75 -45 50])  % this command adjusts the scale of the plot
                       % owing to zoom in on Africa
                       
                       
% Adding title and axis labels
title('Africa velocities in ITRF 2005');
xlabel('Longitude');                    
ylabel('Latitude');  

% strl = ['Rate =' sprintf('%4.1f',a(1)) ' mm/year'];                        
                       
hold on             % this command allows multiple plotting
                       
% _____________________________________________________________________

                       
% DETERMINING IF THE VELOCITIES OF AFRICA ARE BEST FIT BY 1,2 OR MORE
% PLATES

% this command loads in the GPS data provided in ITRF 2005 reference frame
[lo,la,ve,vn,sve,svn,cne,site]=textread('data/africa_itrf2005.all'...
        ,'%f %f %f %f %f %f %f %s');

    
s = 0.7;   % setting a scale owing to adjust the lenght of the arrows

quiver(lo,la,ve*s,vn*s,0,'r','linewidth',2); % plots velocity vectors as  
                                             % arrows with components (u,v)
                                             % at the points (x,y)



% Calculating the rotation vector between Nubia and ITRF 2005
[OM,COM,E,EL,chi2,chi2r,dof] = psvelo2rot('data/velo.nubia',10,1);

                              % psvelo2rot estimates plate angular rotation
                              % and associated statistic from psvelo input 
                              % file

                              
% Calculating a predicted velocity for all the GPS sites
% assuming they are all on Nubia which behaves as a perfect plate
% Owing to do this, three steps are required

% STEP 1: Converting the coordinates of all GPS sites into a geocentric
%         cartesian reference frame

[x,y,z] = wgs2xyz(lo,la,zeros(length(lo),1)); % wgs2xyz converts 
                                              %lo(longitude) and 
                                              % la(latitude)
                                              % ellipsoidal coordinates
                                              % from WGS-84 to ECEF 
                                              % cartesian coordinates
                                            


% STEP 2: Using the rotation vector calculated earlier to compute the
%         predicted velocities at all the sites

[Vxyz,Venu] = rotate(OM,COM,[x y z]);       % rotate computes velocity
                                            % at selected point given
                                            % a rotation vector (OM)



% STEP 3: Plotting the results using quiver
quiver(lo,la,Venu(:,1)*s,Venu(:,2)*s,0,'k','linewidth',2);



% Calculating and plotting the residual velocities to the Nubia plate
% model at all the sites

 res_east = ve-Venu(:,1);       % residual velocities in east
 res_north = vn - Venu(:,2);    % residual velocities in north
 

quiver(lo,la,res_east,res_north,0,'y','linewidth',2);  % this command plots
                                                       % the residual
                                                       % velocities


% Saving the Nubian velocities
fp = fopen('velo.nubia','w');
fprintf(fp, '%f %f %f %f %f %f %f\n', [lo la Venu]');
fclose(fp);



% _____________________________________________________________________

% DIVIDING AFRICA INTO TWO PLATES (Somalia and Nubia)

% Plotting Africa as before
figure(2)
plot(long,lat,'g','linewidth',2)
axis equal
axis([-30 75 -45 50])
                       
% Adding title and axis labels
title('Africa velocities in Nubian-Somalian Reference');
xlabel('Longitude');                    
ylabel('Latitude');  

hold on

% % Plotting the red arrows (CORRIGIR OS COMMENTS)
% [lo,la,ve,vn,sve,svn,cne,site]=textread('data/nubi_soma.revel'...
%         ,'%f %f %f %f %f %f %f %s');    
% s = 0.7;  
% quiver(lo,la,ve*s,vn*s,0,'r','linewidth',2); 


% Calculating the rotation vector between Somalia and Nubia
[OM,COM,E,EL,chi2,chi2r,dof] = psvelo2rot('data/velo.residual.soma',10,1);

% Calculating a predicted velocity for all the GPS sites
% assuming they are all on Nubia which behaves as a perfect plate
% Owing to do this, three steps are required

% STEP 1: Converting the coordinates of all GPS sites into a geocentric
%         cartesian reference frame

[x,y,z] = wgs2xyz(lo,la,zeros(length(lo),1)); % wgs2xyz converts 
                                              %lo(longitude) and 
                                              % la(latitude)
                                              % ellipsoidal coordinates
                                              % from WGS-84 to ECEF 
                                              % cartesian coordinates
                                            


% STEP 2: Using the rotation vector calculated earlier to compute the
%         predicted velocities at all the sites

[Vxyz,Venu] = rotate(OM,COM,[x y z]);       % rotate computes velocity
                                            % at selected point given
                                            % a rotation vector (OM)



% STEP 3: Plotting the results using quiver
quiver(lo,la,Venu(:,1)*s,Venu(:,2)*s,0,'k','linewidth',2);



% Calculating and plotting the residual velocities to the Nubia plate
% model at all the sites

 res_east = ve-Venu(:,1);       % residual velocities in east
 res_north = vn - Venu(:,2);    % residual velocities in north
 

quiver(lo,la,res_east,res_north,0,'y','linewidth',2);  % this command plots
                                                       % the residual
                                                       % velocities
   
                                                       
% % _____________________________________________________________________
% 
% % COMPARING THE ESTIMATE FOR THE NUBIA-SOMALIA OPENING ALONG THE EAST
% % AFRICAN RIFT WITH THAT OF THE REVEL MODEL (Sella et al.,2002), which
% % is a global plate model derived from GPS
% 
% 
% % This command loads in the data for the REVEL model                                                                                                             
% [lo,la,ve,vn,sve,svn,cne]=textread('data/nubi_soma.revel',...
%     '%f %f %f %f %f %f %f');
% 
% % Plotting Africa as before
% figure(3)
% plot(long,lat,'g','linewidth',2)
% axis equal
% axis([-30 75 -45 50])
% 
% % Adding title and axis labels
% title('Africa velocities in Nubian/Somalian Reference Frame');
% xlabel('Longitude');                    
% ylabel('Latitude');  
% 
% 
% hold on
% 
% quiver(lo,la,ve*s,vn*s,0,'r','linewidth',2)
% 
% % Calculating a predicted velocity for all the GPS sites
% % assuming they are all on Nubia which behaves as a perfect plate
% % Owing to do this, three steps are required
% 
% % STEP 1: Converting the coordinates of all GPS sites into a geocentric
% %         cartesian reference frame
% 
% [x,y,z] = wgs2xyz(lo,la,zeros(length(lo),1)); % wgs2xyz converts 
%                                               %lo(longitude) and 
%                                               % la(latitude)
%                                               % ellipsoidal coordinates
%                                               % from WGS-84 to ECEF 
%                                               % cartesian coordinates
%                                             
% 
% 
% % STEP 2: Using the rotation vector calculated earlier to compute the
% %         predicted velocities at all the sites
% 
% [Vxyz,Venu] = rotate(OM,COM,[x y z]);       % rotate computes velocity
%                                             % at selected point given
%                                             % a rotation vector (OM)
% 
% 
% 
% % STEP 3: Plotting the results using quiver
% quiver(lo,la,Venu(:,1)*s,Venu(:,2)*s,0,'k','linewidth',2);
% 
% 
% 
% % Calculating and plotting the residual velocities to the Nubia plate
% % model at all the sites
% 
%  res_east = ve-Venu(:,1);       % residual velocities in east
%  res_north = vn - Venu(:,2);    % residual velocities in north
%  
% 
% quiver(lo,la,res_east,res_north,0,'y','linewidth',2);  % this command plots
%                                                        % the residual
%                                                        % velocities
%    
%                                                        
%                                                        
% % _____________________________________________________________________
% 
% % ASSESSING IF ANATOLIA CAN BE CONSIDERED AS A RIGID PLATE, OR IF THERE IS
% % SIGNIFICANT INTERNAL DEFORMATION
% 
% % Plotting Africa as before
% figure(4)
% plot(long,lat,'g','linewidth',2)
% axis equal
% axis([-30 75 -45 50])
% 
% hold on
% 
% quiver(lo,la,ve*s,vn*s,0,'r','linewidth',2)
% 
% % Calculating the rotation vector between Greece and Turkey
% [OM,COM,E,EL,chi2,chi2r,dof] = psvelo2rot('data/velo.residual.soma',10,1);

