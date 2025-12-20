clear all;clc

load('dataset.mat','XTrain','YTrain')
load('testdata.mat','Noise','Lunkuo','Allcj')

XX=0;
YY=190000;
ZZ=YY-XX;
AA=230000;

XTrain1=XTrain(XX+1:YY);
XTrain1=reshape(XTrain1,100,ZZ/100);

YTrain1=YTrain(XX+1:YY);
YTrain1=reshape(YTrain1,100,ZZ/100); 

XTrain11=XTrain(XX+1:AA);
XTrain11=reshape(XTrain11,100,AA/100);
YTrain11=YTrain(XX+1:AA);
YTrain11=reshape(YTrain11,100,AA/100);
XValidation1=XTrain11(:,(YY/100)+1:AA/100); 
YValidation1=YTrain11(:,(YY/100)+1:AA/100); 

XTrain2=reshape(XTrain1,[100,1,1,ZZ/100]);
XValidation2=reshape(XValidation1,[100,1,1,(AA-YY)/100]);
YTrain2=YTrain1;
YValidation2=YValidation1;

layers = [
    imageInputLayer([100 1 1])
    convolution2dLayer([3 1],128)%[N 1]
    maxPooling2dLayer([2 1])
    reluLayer()
    convolution2dLayer([3 1],128)
    maxPooling2dLayer([2 1])
    reluLayer()
    convolution2dLayer([3 1],128)
    maxPooling2dLayer([2 1])
    reluLayer()
    
    
    fullyConnectedLayer(128)
    reluLayer()
    fullyConnectedLayer(256)
    reluLayer()
    fullyConnectedLayer(512)
    fullyConnectedLayer(100)
    regressionLayer()];

%plot(layerGraph(layers));

options = trainingOptions('adam', ...
    'MiniBatchSize', 50, ...
    'ExecutionEnvironment','gpu', ...
    'MaxEpochs',150, ...
    'LearnRateDropFactor',0.5, ...
    'LearnRateDropPeriod',50, ... 
    'ValidationData',{XValidation2,YValidation2'},...
    'ValidationFrequency',5, ...
    'Verbose',true, ...
    'Shuffle','every-epoch', ... 
    'InitialLearnRate',0.001, ...
    'LearnRateSchedule','piecewise', ...
    'Plots','training-progress');

[net,traininfo] = trainNetwork(XTrain2,YTrain2',layers,options);

% figure(9); plot(traininfo.TrainingRMSE);
% figure(10); plot(traininfo.TrainingLoss);

figure(4)
subplot 311,plot(Noise)
%ExNoise1=(ExNoise-mean(ExNoise))/(max(ExNoise)-min(ExNoise));
Trainsjzs=reshape(Noise,[100,1,1,60]);
Predsjzs = predict(net,Trainsjzs);
%Predsjzs=mapminmax('reverse',Predsjzs,SCPS); 
predsjzs=reshape(Predsjzs',1,[]);
%predsjzs=(predsjzs-mean(scdata173))/(max(scdata173)-min(scdata173));
%predsjzs=(predsjzs*(max(ExNoise)-min(ExNoise)))+mean(ExNoise);
subplot 312,plot(predsjzs)
subplot 313,plot(Allcj)
hold on
ResAll=Noise-predsjzs;
plot(ResAll)

[snr,mse,ncc,sr]=snrmsenccsr(Allcj,ResAll);  
snr
mse
ncc


functions = { ...
    @TrainingRMSE, ...
    @(info) stopTrainingAtThreshold(info,500)};
