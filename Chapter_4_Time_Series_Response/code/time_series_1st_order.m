%{
This program studies time response of 1st order systems
%}

clc
clear
close all

format compact

%% Given data
T=2.5; % time response for the 1D system

%% time range setup
T_max = 10;         % run the test to 10 seconds
dt = T_max*1e-4;    % find the delta-t value 
t = 0:dt:T_max;     % build the time vector

%% Define system

B = [1];
A = [T 1];
% To use the tf function, you must have the Control System Toolbox licensed
% and installed. To find out if you do, type: "ver control" in your Command
% Window or a script.  
G = tf(B,A); 

%% create the figure enviorment
figure(1)
xlim([0 1])

%% step response 

subplot(3,1,1)
hold on
%yline(1,'-','Threshold')
step(G,t)
ylim([0 1.2])


%% Impulse response
subplot(3,1,2)
impulse(G,t)

%% Ramp response

F_ramp = tf([1],[1 0 0])
subplot(3,1,3)
impulse(G*F_ramp,t)
title('Ramp Response') % need to set manually. 















