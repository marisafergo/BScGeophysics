% Inverse Theory - Practical 3: Best Linear unbiased estimator

% The aim of this practical is to set up a 
% problem to be solved by the BLUE then demonstrate that the BLUE is 
% unbiased and gives better results than the ULSE. 

% BLUE (best linear unbiased estimator)
% ULSE (unweighted least squares estimator)


%------------------------------------
%       Marisabel Gonzalez
%           16/10/2018
%------------------------------------

% Clearing workspace, figures and command window
clear all
close all
clc

%------------------------------------
%           NOMENCLATURE
%------------------------------------
% A: total subsidence [m]
% bin_number: optimal number of bins rounded to nearest 5 
% blue_h: sample variances for heights using BLUE
% blue_subs: sample variances for subsidences using BLUE
% d_model1-2: estimated model parameters from 1000 iterations
% d_true: true height [m]
% G:forward operator
% h0: height at t=0 [m]
% m: given parameters
% m1-3: model parameters
% noise1-3: Gaussian random noise
% noise_scaled1-3: noise scaled 
% Qdd: variance-covariance matrix
% Qmm: variance-covariance matrix of the model parameters
% stdev: standard deviation [days]
% sturge: Sturge's rule equation for optimal bin number estimation
% subs_curve: subsidence curve
% t: time [days]
% ulse_h: sample variances for heights using ULS
% ulse_subs: sample variances for subsidences using ULS



% Setting up d and G
t = [0;60;120;180;240;300];

G_one = ones(6,1);
G = [G_one,(exp(-t/150)-1)];  



% Assuming h0 and A values in m
h0 = 151;
A = 0.18;
m = [h0;A];



% Computing d_true assuming no measurement errors
d_true = G*m;


% Plotting true measurements (d_true) against time
plot(t,d_true, 'bo');
xlabel('Time [days]');
ylabel('True height [m]');
title('True height as a function of time');



% Variance-covariance matrix
stdev = [0.02;0.04;0.03;0.02;0.03;0.01];
Qdd = diag(stdev.*stdev);



% Computing random noise (assuming Gaussian distribution) to represent the
%error for each of the measurements
rng(992);
noise1 = randn(6,1);
noise_scaled1 = noise1.*stdev;



% Simulated measurements
d = d_true + noise_scaled1;



% Plotting simulated measurements (d) against time
hold on
plot(t,d, 'gx');



% Computing BLUE (best linear unbiased estimator)
m1 = inv( G'*inv(Qdd)*G ) * G'*inv(Qdd)*d;
subs_curve = G*m1;



% Plotting the subsidence curve
hold on
plot(t,subs_curve,'r-');
legend('True heights','Simulated measurements','Subsidence curve');



% Estimating model parameters for 1000 iterations using BLUE
m2 = zeros(2,1000);

for i = 1:1000
    
    noise2 = randn(6,1);
    noise_scaled2 = noise2.*stdev;
    d_model1 = d_true + noise_scaled2; 
    m2(:,i) = inv(G'*inv(Qdd)*G)*G'*inv(Qdd)*d_model1;

end



% Determining optimal number of bins using Sturge's Rule
sturge = 1 + 3.322*log(length(m2));
bin_number = round( sturge/5 )*5; % roundind to nearest 5



% Plotting histograms for the height model parameters
figure(2)
hist(m2(1,:),bin_number);
xlabel('Height [m]');
ylabel('Frequency');
title('Gaussian histogram of height model parameters for 1000 iterations');



% Adding the true value to the histogram as a vertical line
hold on
x = [h0,h0];
y = ylim;
plot(x,y,'r-','Linewidth',2);
legend('Model Parameters','True Height');



% Plotting histograms for the subsidence model parameters
figure(3)
hist(m2(2,:),bin_number);
xlabel('Subsidence [m]');
ylabel('Frequency');
title('Gaussian histogram of subsidence model parameters for 1000 iterations');



% Adding the true value  to the histogram as a vertical line
hold on
x = [A,A];
y = ylim;
plot(x,y,'r-','Linewidth',2);
legend('Model Parameters','True Subsidence');



% Plotting height and subsidence model parameters in the same figure
figure(4)
scatter(m2(1,:),m2(2,:),'.');
xlabel('Height [m]');
ylabel('Subsidence [m]');
title('Height and subsidence model parameters for 1000 iterations');



% Variance-covariance matrix for the model parameters using BLUE 
Qmm = inv(G'*inv(Qdd)*G);

blue_h = var(m2(1,:));
blue_subs = var(m2(2,:));



% Estimating model parameters for 1000 iterations using ULSE
m3 = zeros(2,1000);

for i = 1:1000
    
    noise3 = randn(6,1);
    noise_scaled3 = noise3.*stdev;
    d_model2 = d_true + noise_scaled3; 
    m3(:,i) = inv(G'*G)*G'*d_model2;
    
end



% Computing the sample variances for each model parameter using ULSE
ulse_h = var(m3(1,:));
ulse_subs = var(m3(2,:));



% Displaying on screen variance results of both methods
disp(['The sample variances using BLUE for height and subsidence' ... 
    ' are: ' num2str(blue_h) ' and ' num2str(blue_subs)])
disp(['The sample variances using ULSE for height and subsidence' ... 
    ' are: ' num2str(ulse_h) ' and ' num2str(ulse_subs)])


%------------------------------------
%              THE END
%------------------------------------



