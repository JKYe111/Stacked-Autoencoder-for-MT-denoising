clear all;clc

%% load different networks
load('SAE.mat')
% load("FFN.mat")

%% load different test dataset
load('TestImpulse.mat','Noise','Lunkuo','Allcj')

%% Process & Plot
WTdenoise=fun_WT(Noise); % WT process
figure(1)
subplot 211, plot(Noise)
subplot 212, plot(WTdenoise)
[snrW,mseW,nccW,srW] = snrmsenccsr(Allcj, WTdenoise);  
snrW
mseW
nccW

figure(2)
subplot 311, plot(Noise)

Trainsjzs = reshape(Noise, [100,1,1,60]); % SAE/FFN setup

Predsjzs = predict(net, Trainsjzs); % Mapping

%Predsjzs = mapminmax('reverse',Predsjzs,SCPS); % reverse normalization

predsjzs = reshape(Predsjzs', 1, []);

%predsjzs=(predsjzs-mean(scdata173))/(max(scdata173)-min(scdata173));
%predsjzs=(predsjzs*(max(ExNoise)-min(ExNoise)))+mean(ExNoise);

subplot 312, plot(predsjzs) % predicted noise

subplot 313, plot(Allcj)
hold on
ResAll = Noise - predsjzs;

plot(ResAll)

%% calculate metrics
[snr,mse,ncc,sr] = snrmsenccsr(Allcj, ResAll);  
snr
mse
ncc

