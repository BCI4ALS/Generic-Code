%% Ex6_315025148_204133151 
close all; clear all; clc;

%% loading

load('motor_imagery_train_data');

%% Data

data = P_C_S.data; %[µV]
numTrials = size(data,1); % number of trials
numSamples = size(data,2); % number of samples
numChannels = P_C_S.numberchannels -1; % electrodes number
fs = P_C_S.samplingfrequency; % sampling rate [Hz]
dt = 1/fs; % [sec]
t = numSamples/fs; % total time [sec] 
bin = 0:dt:t; % time vector [sec]
imageryStart = 2.25*fs + 1; % Imagery starting point [sec]
imageryEnd = 6*fs; % Imagery end point [sec]
imageryDur = (6-2.25)*fs; % Duration of imagery [sec]
leftIndicator = P_C_S.attribute(3,:); % 1 = left trial
rightIndicator = P_C_S.attribute(4,:); % 1 = right trial
numSubplots = 20; % this is for eeg visualization
fontSize = 15;
freqRange = [1 40]; % frequencies range[Hz]
frequencies = freqRange(1):0.1:freqRange(2); % frequencies vector [Hz]
window = 1.5*fs; % for pwelch [sec]
noverlap = []; % No overlap [sec]

% spliting the Data base on sides
leftData = side_data_extractor(data,leftIndicator,numTrials,numSamples,numChannels,imageryStart,imageryEnd); %[µV]
rightData = side_data_extractor(data,rightIndicator,numTrials,numSamples,numChannels,imageryStart,imageryEnd); %[µV]


%% Visualization

% choosing randomly 20 trials from each side
leftPerm = randperm(size(leftData,1),numSubplots); 
leftTrials = leftData(leftPerm,:,:);
rightPerm = randperm(size(rightData,1),numSubplots);
rightTrials = rightData(rightPerm,:,:);

% ploting Visualization
leftFig = figure; 
eeg_visualization(leftFig, leftTrials, 'Left EEG Signal', numSubplots, bin, 0.8*fontSize,imageryStart, imageryEnd);
rightFig = figure;
eeg_visualization(rightFig, rightTrials, 'Right EEG Signal', numSubplots, bin, 0.8*fontSize, imageryStart, imageryEnd);


%% Power Spectrum
chanNames = ['channel C3';'channel C4']; 
[pwelchLeft,pwelchRight] = calc_spectrum(leftData,rightData,numChannels,numTrials,frequencies,window,noverlap,fs);
plot_spectrum(pwelchRight,pwelchLeft,frequencies,numChannels,chanNames);


%% spectrogram

% Data from beginning of sampling
leftDataAll = side_data_extractor(data,leftIndicator,numTrials,numSamples,numChannels,1,imageryEnd);
rightDataAll = side_data_extractor(data,rightIndicator,numTrials,numSamples,numChannels,1,imageryEnd);

hotmap(rightDataAll,leftDataAll,numTrials,noverlap,fs);

% Extracted bands and times for each band from viewing the heatmaps per electrode
C3Bands = {[15.8,17.2],[8.2,10.3],[8.5,9.8]}; % [Hz]
C4Bands = {[16.5,17.3],[16.4,16.8],[15.7,16.8]};% [Hz]
C3DiffC4Bands = {[8.5,10.4],[15,17]};% [Hz]
C3DiffC4Times = {589:627,537:704};
C3Times = {563:717,499:627,589:627};
C4Times = {550:601,589:627,678:730};

%% power band and histogram

plot_histogram(C3Bands,C4Bands,C3DiffC4Bands,rightData,leftData,fs);


%% Classification

runs = 5; % We ran the CV @runs times to average out the variation
comNum = 8; % number of principal components to use in the model 
bias = 0; % we've tried adding manual bias when we saw we were always saying more left than right, but it improve our prediction
kfold = 6; % number of partitions for cross validation
                     
features = get_features(data,C3Bands,C3Times,C4Bands,C4Times,C3DiffC4Bands,C3DiffC4Times,imageryStart,imageryEnd,numTrials,window,noverlap,frequencies,fs); % features for classification
projectedData = calc_pca(features,comNum,numTrials); % uses PCA for dimensionality reduction and returns the projected result for the classifier as well as forlater visualization 
[~,accBest,foldsAcc,foldsSTD,stdRuns,trainFoldAcc,trainFoldSTD,trainAcc] = custom_classifier(projectedData,numTrials,rightIndicator,runs,kfold,bias); % classification



%% Display classification results to command window

% full model results
disp('## Complete model results (validation): ##');
disp(['Run #' num2str(runs) ' Accuracy (training): ' num2str(1-mean(trainFoldAcc)) '%' '   SD: ' num2str(trainFoldSTD)]);
disp(['Run #' num2str(runs) ' Accuracy (validation): ' num2str(1-mean(foldsAcc)) '%' '   SD: ' num2str(foldsSTD)]);
disp(['Whole model accuracy (training): ' num2str(100*mean(1-trainAcc)) '%' '   SD: ' num2str(std(trainAcc))]);
disp(['Whole model accuracy (validation): ' num2str(100*accBest) '%' '   SD: ' num2str(stdRuns)]);
disp(newline);

% Example with 1 feature
disp('## Example with 1 feature: ##');
[~,accOneFeat,foldsOneFeat,foldsSTDOneFeat,stdRunsOneFeat,trainFoldAccOneFeat,trainFoldSTDOneFeat,trainAccOneFeat] = custom_classifier(features(:,1),numTrials,rightIndicator,runs,kfold,bias);
disp(['Run #' num2str(runs) ' Accuracy (training): ' num2str(1-mean(trainFoldAccOneFeat)) '%' '   SD: ' num2str(trainFoldSTDOneFeat)]);
disp(['Run #' num2str(runs) ' Accuracy (validation): ' num2str(1-mean(foldsOneFeat)) '%' '   SD: ' num2str(foldsSTDOneFeat)]);
disp(['1-feature model accuracy (training): ' num2str(100*mean(1-trainAccOneFeat)) '%' '   SD: ' num2str(std(trainAccOneFeat))]);
disp(['1-feature model accuracy (validation): ' num2str(100*accOneFeat) '%' '   SD: ' num2str(stdRunsOneFeat)]);



%% PCA Visualization

scatter_me(projectedData,rightIndicator,leftIndicator,fontSize);


%% Prediction
load motor_imagery_test_data.mat;

testData = data(:,:,1:2);
testFeatures = get_features(testData,C3Bands,C3Times,C4Bands,C4Times,C3DiffC4Bands,C3DiffC4Times,imageryStart,imageryEnd,size(testData,1),window,noverlap,frequencies,fs);

Predictions = classify(testFeatures,features,P_C_S.attribute(4,:)); % 1 = 'right' trial

figure;
imshow('ThisIsBadCoding.jpeg');
