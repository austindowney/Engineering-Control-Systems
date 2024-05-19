clear
close all
clc



syms x
fplot(lambertw(x))
hold on
fplot(lambertw(-1,x))
hold off
axis([-0.5 4 -4 2])
title('Lambert W function, two main branches')
legend('k=0','k=1','Location','best')

figure()
fplot(lambertw(x))
xlabel('x')
ylabel('y')

%% build the systeem

tt = linspace(0,10,100000);
T =1.2;
xx = 1/T*exp(-tt./T); 

figure()
plot(tt,xx)


% fint t_1/2
[a,b] = min(abs(xx-(xx(1)/2)));
tt_half = tt(b)

labmert_in = -(tt_half/2)
T_calc = -tt_half/real(lambertw(-1,labmert_in))


%% Check with the equation from Dr. G. T=1.4*tt_half

T_dr_G = 1.4*tt_half




















