clear
close all
clc


%% calculate system values
c = 15;     % N/(m/sec)
k = 700;    % N/m,
m = 7;      % kg
w_n = sqrt(k/m)     % natural frequency in rad/sec
z = c/(2*sqrt(k*m)) % damping ratio
w_d = w_n*sqrt(1-z^2);   % damped natural frequency

%% calculate transfer function G(s)
B = [w_n^2];
A = [1 2*z*w_n w_n^2];
G = tf(B,A) % build the transfer function


%% Plot one below the other step response, impulse response, ramp response
% time range setup
T_max = 10;         % run the test to 10 seconds
dt = T_max*1e-4;    % find the delta-t value 
t = 0:dt:T_max;     % build the time vector

figure(1)
hold on
step(G,t)
ylim([0 2])


%% Check the limulink numbers
tr = 0.169
tp = 0.317
Mp = 0.713

z
test_phi = pi*(1-(tr/tp))

z_1 = sqrt(1-sin(test_phi)^2)
z_2 = abs(log(Mp))/sqrt(pi^2+(log(Mp))^2)


%% plot x(t)

phi = asin(sqrt(1-z^2));
xx = 1-((1/(sqrt(1-z^2))).* exp(-z*w_n*t) .* sin(w_d*t+phi));

figure()
plot(t,xx)


