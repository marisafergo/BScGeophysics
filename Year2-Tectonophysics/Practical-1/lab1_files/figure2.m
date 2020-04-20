% ADDING A DIRECTORY TO SEARCH A PATH
addpath mbin/gps_ec mbin/stats


% LOADING A COASTLINE FILE AND MAKING A BASEMAP FOR AFRICA
load('data/coast.mat');


% PLOTTING AND ZOOMING IN ON AFRICA

hold on             % this command allows multiple plotting



plot(long,lat,'g','linewidth',2) % the file aready contain the information
                                 % of these variables, for this reason 
                                 % they haven't been defined within the scrip

                    
axis equal  % this command sets the aspect ratio so that the data 
            % units are the same in every direction
            

axis([-30 75 -45 50])  % this command adjusts the scale of the plot
                       % owing to zoom in on Africa
                       
                       
% DIVIDING AFRICA INTO TWO PLATES (Somalia and Nubia)



% Plotting Africa as before

plot(long,lat,'g','linewidth',2)
axis equal
axis([-30 75 -45 50])

% Plotting the red arrows (CORRIGIR OS COMMENTS)
[lo,la,ve,vn,sve,svn,cne,site]=textread('data/africa_itrf2005.all'...
        ,'%f %f %f %f %f %f %f %s');    
s = 0.7;  
quiver(lo,la,ve*s,vn*s,0,'r','linewidth',2); 


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
 

quiver(lo,la,res_east,res_north,0,'b','linewidth',2);  % this command plots
                                                       % the residual
                                                       % velocities
   
   
   