%{
Example on the use of residue to find poles
%}
clear
clc
close all

% Define B and A
B = [3, 5];
A = [1, 3, 2]

% find the poles and the residuales 
[r, p, k] = residue(B,A)

% use poles and residuals to calculate the A and B
[B_new, A_new] = residue(r, p, k)














