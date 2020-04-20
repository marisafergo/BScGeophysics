% Inverse Theory
% Practical 5: Mixed-determined problem and singular value decomposition



%------------------------------------
%       Marisabel Gonzalez
%           30/10/2018
%------------------------------------

% Clearing workspace, figures and command window
clear all
close all
clc

%------------------------------------
%           NOMENCLATURE
%------------------------------------
% ray_num:
% time: [in sec] (time is the data)
% l1-3:
% s1-3:
% v_ref:
% slow_ref
% rp1-3: ray path
% check_o: check if orthogonal
% check_G: check if equal to G
% Gg: Moore Penrose Inverse (generalised unverse)

% Given information
ray_num = [1 ;2 ;3 ;4 ;5];
time = [(5.43*10^(-6)) (3.18*10^(-6)) (3.65*10^(-6)) (5.5*10^(-6)) (4.35*10^(-6))];

% Equation for the first ray parameter 
x = 0.01;
v_ref = 6000;
slow_ref = 1/v_ref;
rp1= (x*1)*v_ref;
rp2= (x*2)*v_ref;
rp3= (x*3)*v_ref;
d_t_1 = rp1 + rp2 + rp3; 

% Estimating the slowness for all the rays
%act_slow = d/t;
%del_s = act_slow - slow_ref;

% Path length taken by each ray
l1 = [x, x, x, 0, 0, 0];
l2 = [x, 0, 0, x, 0, 0];
l3 = [0, x, 0, 0, x, 0];
l4 = [0, sqrt(2*(x^2)), 0, 0, sqrt(2*(x^2)), 0];
l5 = [sqrt(2*(x^2)), 0, 0, 0, sqrt(2*(x^2)), 0];

% Setting d and G
d = time;
G = [ l1; l2; l3; l4; l5];

% Singular value decomposition of G
[U,S,V] = svd(G);

% Checking if orthogonal
check_o = U(:,1)' .* U(:,4);  % if zero = orthogonal

% Defining Sp containing non-zero singular values of S
% ( ~= 0 along the diagonal, <1e-7 is considered 0 )
Sp = S(1:4, 1:4);

% Defining Vp containing non-zero singular values of V
Vp = V(:, 1:4);

% Defining Up containing non-zero singular values of U
Up = U(:, 1:4);

% Checking UpxSpxVp' = G
% ( <1e-7 is considered 0 )
check_G = Up * Sp * Vp';

if check_G == G
    disp('G and check_G are equal')
else 
    disp('G and check_G are different');
end

% Computing m_hat
Gg = Vp * inv(Sp) * Up';
m_hat = Gg .* d;

m_hat_1(1,1:3) = m_hat(1:3,1);
m_hat_1(2,1:3) = m_hat(4:6,1);
imagesc(m_hat_1)
axis equal tight




%------------------------------------
%              THE END
%------------------------------------
