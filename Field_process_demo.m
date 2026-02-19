clear all;clc

%% load network
load('SAE.mat')

%% load data
load('EX.mat')
load('EY.mat')
load('HX.mat')
load('HY.mat')
data=EX;  % EY, HX, HY
data=data-mean(data);
%% Process & Plot
figure
subplot 311, plot(data)

Noisydata = reshape(data, [100,1,1,length(data)/100]); % SAE/FFN setup

Prednoise = predict(net, Noisydata); % Mapping

Prednoise = reshape(Prednoise', 1, []);

subplot 312, plot(Prednoise) % predicted noise

ResAll = data - Prednoise;

subplot 313, plot(ResAll) % denoised data