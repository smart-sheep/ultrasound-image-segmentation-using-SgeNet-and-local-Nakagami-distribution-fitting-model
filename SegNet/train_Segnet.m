%The following codes are to train a SegNet[1] network for ultrasound image segmentation
% Breast Ultrasound Dataset:[2] Huang Q, Huang Y, Luo Y, et al. Segmentation of breast ultrasound 
%  image with semantic classification of superpixels[J]. Medical Image Analysis, 2020, 61: 101657.
% Reference:[1] Badrinarayanan V, Kendall A, Cipolla R. Segnet: A deep convolutional encoder-decoder architecture for image segmentation[J]. 
%               IEEE transactions on pattern analysis and machine intelligence, 2017, 39(12): 2481-2495.
%author:Cui Wenchao
% Date:2021.09.12

clc;clear all;close all;
%% Load train images and pixel labels 
dataSetDir = fullfile('E:\SegNet\SegNet for ultrasound image segmentation','train');% The directory of the dataset 
imageDir = fullfile(dataSetDir,'images');%the folder of the train image dataset
labelDir = fullfile(dataSetDir,'labels');%the folder of the label image dataset,i.e.,the groud truth of segmentation
imds=imageDatastore(imageDir);
classNames=["tumor","background"];
labelIDs=[1 0];
pxds=pixelLabelDatastore(labelDir,classNames,labelIDs);
I=readimage(imds,10);
C=readimage(pxds,10);
mask=C=='tumor';
% figure
% B=labeloverlay(I,C,'Transparency',0.5,'Colormap','gray');
% imshow(B)
figure
imshow(I);hold on;axis off,axis equal;
contour(mask,[0.5 0.5],'r','LineWidth',2);
%%
%%
%% load validation images and pixel labels
ValdataSetDir = fullfile('E:\SegNet\SegNet for ultrasound image segmentation','validation');% The directory of the dataset 
ValimageDir = fullfile(ValdataSetDir,'images');%the folder of the train image dataset
VallabelDir = fullfile(ValdataSetDir,'labels');%the folder of the label image dataset,i.e.,the groud truth of segmentation
Valimds=imageDatastore(ValimageDir);
% classNames=["tumor","background"];
% labelIDs=[1 0];
Valpxds=pixelLabelDatastore(VallabelDir,classNames,labelIDs);
ValidationData=combine(Valimds,Valpxds);
%%
%% Creat SegNet Network with an encoder-decoder depth of 4
imageSize=[128,128,1];
numClasses=2;
encoderDepth=4;
lgraph=segnetLayers(imageSize,numClasses,encoderDepth);
figure
plot(lgraph);
%%
%% Train SegNet Network for Semantic Segmentation
%% （1）without image augmentation
% pximds=pixelLabelImageDatastore(imds,pxds);%creat a datastore for training the network
% options=trainingOptions('adam','MiniBatchSize',32,'InitialLearnRate',1e-3,'MaxEpochs',50,'VerboseFrequency',10,'Plots','training-progress');
% net=trainNetwork(pximds,lgraph,options);
%%
%% (2) with image augmentation
augmenter=imageDataAugmenter('RandRotation',[-10,10],'RandXReflection',true,'RandYReflection',true, 'RandXTranslation',[-3 3], 'RandYTranslation',[-3 3]);
pximds=pixelLabelImageDatastore(imds,pxds,'DataAugmentation',augmenter);%creat a augmented datastore for training the network
options=trainingOptions('adam','MiniBatchSize',32,'InitialLearnRate',1e-3,'MaxEpochs',50,'ValidationData',ValidationData,'ValidationFrequency',20,'VerboseFrequency',10,'Plots','training-progress');
net=trainNetwork(pximds,lgraph,options);
%%
%%
save 'Segnet_trained.mat' net;
%%







