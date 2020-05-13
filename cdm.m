clc;
clear all;
close all;
M = 8;
walsh = hadamard(M);
% Selecting lines from the walsh matrix
a1 = walsh(3,:);
a2 = walsh(5,:);
a3 = walsh(7,:);

msgA = [0; 1; 1]; % Message of user A
msgB = [1; 1; 0]; % Message of user B
msgC = [1; 0; 1]; % Message of user C

eA = a1 .* msgA
eB = a2 .* msgB
eC = a3 .* msgC

% Combined Encoded Message
compMsg = eA + eB + eC 

deco1=compMsg.*a1;
deco2=compMsg.*a2;
deco3=compMsg.*a3;
decomsg1=sum(deco1,2);
decomsg2=sum(deco2,2);
decomsg3=sum(deco3,2);
% Decoded message from each user
dA = ((1/M)* decomsg1)' 
dB = ((1/M)* decomsg2)'
dc = ((1/M)* decomsg3)'
