addpath mbin/gps_ec mbin/stats
%Load a coastline file and make a basemap for Africa:
close all
figure(1)
subplot(1,2,1)
load data/coast.mat
plot(long,lat,'b')
axis equal 
%Zoom in on Africa: e.g.
axis([-30 75 -45 50])
%First load in the GPS data that have been provided in ITRF 2005 reference frame.
[lo,la,ve,vn,sve,svn,cne,site]=textread('data/africa_itrf2005.all','%f %f %f %f %f %f %f %s');
%First set a scale that you can use to adjust the length of the arrows, e.g.:
s=0.7;
%Then plot on the map using quiver, e.g.:
hold on
quiver(lo,la,ve*s,vn*s,0,'b');

%scale bar
quiver(-20,-35,30*s,0,0,'k') % 30 mm/yr scale
text(-20,-30,'30 mm/yr')

%title/axes
xlabel('longitude')
ylabel('latitude')
title('Africa velocities in ITRF 2005')


%Run psvelo2rot like this:
[OM,COM,E,EL,chi2,chi2r,dof] = psvelo2rot('data/velo.nubia',10,1);

%plot pole
plot(E(1),E(2),'b*')
axis([-30 75 -85 50])

%Step 1: Convert coordinates of all GPS sites into a geocentric, Cartesian reference frame:
[x,y,z] = wgs2xyz(lo,la,zeros(length(lo),1));
%Step 2: Use the rotation vector that you calculated earlier to calculate predicted velocities at all the sites:
[Vxyz,Venu] = rotate(OM,COM,[x y z]);
%Step 3: Plot the results using quiver, e.g.:
quiver(lo,la,Venu(:,1)*s,Venu(:,2)*s,0,'r');

% Q how well do they fit?
%compute residuals to numbian plate model (i.e. velocities of all sites in
%nubian reference frame
Vnub = [ve vn] - Venu(:,1:2);
% plot residual velocities
quiver(lo,la,Vnub(:,1)*s,Vnub(:,2)*s,0,'g');

% The three site with the biggest residuals on the Somalian plate are in file velo.residual.soma. We can used these to compute soma/nubia angular rotation
[OM,COM,E,EL,chi2,chi2r,dof] = psvelo2rot('data/velo.residual.soma',10,1);
% and plot location of pole of rotation
plot(180+E(1),-E(2),'*');  
quiver(-20,-35,10*s,0,0,'k') % 10 mm/yr scale

%(note that the pole the program gave was the one on the other side of the planet, hence the 180+E(1) and -E(2))
subplot(1,2,2)
plot(long,lat,'b')
hold on
axis equal
%zoom in on Africa
axis([-30 75 -45 50])
%% Calculate and plot somalian predicted vectors in nubian reference frame
%first plot real velocities in somalian reference
s=3;
quiver(lo,la,Vnub(:,1)*s,Vnub(:,2)*s,0,'g');
[Vxyz,Venu] = rotate(OM,COM,[x y z]);
% Plot the predicted velocities in a Somalian Reference frame.
quiver(lo,la,Venu(:,1)*s,Venu(:,2)*s,0,'r');
plot(180+E(1),-E(2),'*');  
%compute residuals to numbian plate model (i.e. velocities of all sites in
%nubian reference frame
Vsom = [Vnub(:,1) Vnub(:,2)] - Venu(:,1:2);
% plot residual velocities
quiver(lo,la,Vsom(:,1)*s,Vsom(:,2)*s,0,'k');
quiver(-20,-35,10*s,0,0,'k') % 10 mm/yr scale
text(-20,-30,'10 mm/yr')

%title/axes
xlabel('longitude')
ylabel('latitude')
title('Africa velocities in Nubia/Somalia reference')


%% Plot NUBIA-SOMALIA plate motions from REVEL and our model
figure(2)
plot(long,lat,'b')
axis equal
%zoom in on Africa
axis([-30 75 -45 50])
[lo,la,ve,vn,sve,svn,cne]=textread('data/nubi_soma.revel','%f %f %f %f %f %f %f');
s=3;
hold on
quiver(lo,la,ve*s,vn*s,0,'b');
[x,y,z] = wgs2xyz(lo,la,zeros(length(lo),1));
[Vxyz,Venu] = rotate(OM,COM,[x y z]);
quiver(lo,la,Venu(:,1)*s,Venu(:,2)*s,0,'r');
quiver(-20,-35,10*s,0,0,'k') % 10 mm/yr scale
text(-20,-30,'10 mm/yr')

%title/axes
xlabel('longitude')
ylabel('latitude')
title('Africa velocities in Nubian/Somalian Reference Frame')

%% ANATOLIA Repeat above steps for Anatolia
figure(3)
subplot(2,1,1)
plot(long,lat,'b')
axis equal
%zoom in on Turkey
axis([15 45 33 45])
[lo,la,ve,vn,sve,svn,cne,site]=textread('data/nocquet_eurasia.all','%f %f %f %f %f %f %f %s');
s=0.1;
hold on
quiver(lo,la,ve*s,vn*s,0,'b');
%[lo,la,ve,vn,sve,svn,cne,site]=textread('data\nocquet_eurasia.anat','%f %f %f %f %f %f %f %s');
%quiver(lo,la,ve*s,vn*s,0,'r');
[OM,COM,E,EL,chi2,chi2r,dof] = psvelo2rot('data/nocquet_eurasia.anat',10,1);
[x,y,z] = wgs2xyz(lo,la,zeros(length(lo),1));
[Vxyz,Venu] = rotate(OM,COM,[x y z]);
Vanat = [ve vn] - Venu(:,1:2);

subplot(2,1,2)
plot(long,lat,'b')
hold on
axis equal
%zoom in on Turkey
axis([15 45 33 45])
quiver(lo,la,Vanat(:,1)*s,Vanat(:,2)*s,0,'r');
quiver(17,35,10*s,0,0,'k') % 10 mm/yr scale


