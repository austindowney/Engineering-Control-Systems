%{
This program studies time response of 2nd order systems
%}

clc
clear
close all

format compact


%% Given data
fn = 5; % time response for the 1D system
wn = 2*pi()*fn
z = 0.035

%% time range setup
T_max = 10;         % run the test to 10 seconds
dt = T_max*1e-4;    % find the delta-t value 
t = 0:dt:T_max;     % build the time vector

%% Define system
B = [wn^2];
A = [1 2*z*wn wn^2];
G = tf(B,A); 

%% create the figure enviorment
figure(1)
xlim([0 1])

%% step response 
subplot(3,1,1)
hold on
step(G,t)
ylim([0 2])

%% Impulse response
subplot(3,1,2)
impulse(G,t)
ylim([-35 35])

%% Ramp response
F_ramp = tf([1],[1 0 0])
subplot(3,1,3)
impulse(G*F_ramp,t)
xlim([0 1])
ylim([0 1])
title('Ramp Response') % need to set manually. 
















