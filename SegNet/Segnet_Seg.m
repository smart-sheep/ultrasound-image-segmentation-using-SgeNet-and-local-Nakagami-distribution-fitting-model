%the following codes are to evaluate the segmentation results using a
%pretrained Segnet Network.
%author:Cui Wenchao
% Date:2021.09.12

load Segnet_trained.mat;
%% Load test images and pixel labels 
dataSetDir = fullfile('E:\SegNet\SegNet for ultrasound image segmentation','test');% The directory of the dataset 
testImageDir = fullfile(dataSetDir,'images');%the folder of the test image dataset
testLabelDir = fullfile(dataSetDir,'labels');%the folder of the label image dataset,i.e.,the groud truth of segmentation
t1=cputime;
imds=imageDatastore(testImageDir);
classNames=["tumor","background"];
labelIDs=[1 0];
pxdsTruth=pixelLabelDatastore(testLabelDir,classNames,labelIDs);
pxdsResults=semanticseg(imds,net,'WriteLocation','segResults');
t=cputime-t1;
metrics = evaluateSemanticSegmentation(pxdsResults,pxdsTruth);
