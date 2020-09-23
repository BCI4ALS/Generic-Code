%
close all; clear all; clc;
load('motor_imagery_train_data');
data = P_C_S.data;


%% parse data structure and define params

numTrials = size(data,1); % number of trials
numSamples = size(data,2); % number of samples
numChannels = P_C_S.numberchannels -1; % electrodes number
leftIndicator = P_C_S.attribute(3,:); % 1 = left trial
rightIndicator = P_C_S.attribute(4,:); % 1 = right trial

fs = P_C_S.samplingfrequency; % sampling rate [Hz]
t = 0:1/fs:(numSamples-1)/fs; % time vector [sec]
imageryStart = 2.25*fs + 1; % Imagery starting point [sec]
imageryEnd = 6*fs; % Imagery end point [sec]
imageryDur = (6-2.25)*fs; % Duration of imagery [sec]

freqVec = 1:0.1:40; % frequencies vector [Hz]
welchWindow = 1.5*fs; % for pwelch [sec]
noverlap = []; % No overlap [sec]

numSubplots = 20; % this is for eeg visualization
fontSize = 15;
chanNames = ['channel C3';'channel C4']; 

% Extracted bands and times for each band from viewing the heatmaps per electrode
C3Bands = {[15.8,17.2],[8.2,10.3],[8.5,9.8]}; % [Hz]
C4Bands = {[16.5,17.3],[16.4,16.8],[15.7,16.8]};% [Hz]
C3DiffC4Bands = {[8.5,10.4],[15,17]};% [Hz]
C3DiffC4TimesSmp = {589:627,537:704};
C3TimesSmp = {563:717,499:627,589:627};
C4TimesSmp = {550:601,589:627,678:730};

%classification params
runs = 5; % We ran the CV @runs times to average out the variation
comNum = 8; % number of principal components to use in the model 
bias = 0; % we've tried adding manual bias when we saw we were always saying more left than right, but it improve our prediction
kfold = 6; % number of partitions for cross validation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% spliting the Data base to Left and Right
leftData = data(logical(leftIndicator),imageryStart:imageryEnd,1:numChannels);
rightData = data(logical(rightIndicator),imageryStart:imageryEnd,1:numChannels);

%% Time Series Visualization
leftPerm = randperm(size(leftData,1),numSubplots); % choosing randomly 20 trials from each side
eeg_visualization(leftData(leftPerm,:,:), 'Left EEG Signal', numSubplots, t, 0.8*fontSize,imageryStart, imageryEnd);
rightPerm = randperm(size(rightData,1),numSubplots);
eeg_visualization(rightData(rightPerm,:,:), 'Right EEG Signal', numSubplots, t, 0.8*fontSize, imageryStart, imageryEnd);

%% Power Spectrum
[pwelchLeft,pwelchRight] = calc_spectrum(leftData,rightData,numChannels,numTrials,freqVec,welchWindow,noverlap,fs);
plot_spectrum(pwelchRight,pwelchLeft,freqVec,numChannels,chanNames);

%% spectrogram
hotmap(data(logical(leftIndicator),:,1:numChannels),data(logical(rightIndicator),:,1:numChannels),numTrials,noverlap,fs);

%% power band and histogram
plot_histogram(C3Bands,C4Bands,C3DiffC4Bands,rightData,leftData,fs);

%% Extract features and their primary components
features = get_features(data,C3Bands,C3TimesSmp,C4Bands,C4TimesSmp,C3DiffC4Bands,C3DiffC4TimesSmp,imageryStart,imageryEnd,numTrials,welchWindow,noverlap,freqVec,fs);
% uses PCA for dimensionality reduction and returns the projected result for the classifier as well as forlater visualization
%projectedData = calc_pca(features,comNum,numTrials);  
[pcaCoeff,projectedData,~] = pca(features,'NumComponents',comNum);

%pca visualization
scatter_me(projectedData,rightIndicator,leftIndicator,fontSize);

%% Classification cross-validation to improve features               
[~,accBest,foldsAcc,foldsSTD,stdRuns,trainFoldAcc,trainFoldSTD,trainAcc] =...
    custom_classifier(projectedData,numTrials,rightIndicator,runs,kfold,bias);

% full model results
disp('## Complete model results (validation): ##');
disp(['Run #' num2str(runs) ' Accuracy (training): ' num2str(1-mean(trainFoldAcc)) '%' '   SD: ' num2str(trainFoldSTD)]);
disp(['Run #' num2str(runs) ' Accuracy (validation): ' num2str(1-mean(foldsAcc)) '%' '   SD: ' num2str(foldsSTD)]);
disp(['Whole model accuracy (training): ' num2str(100*mean(1-trainAcc)) '%' '   SD: ' num2str(std(trainAcc))]);
disp(['Whole model accuracy (validation): ' num2str(100*accBest) '%' '   SD: ' num2str(stdRuns)]);
disp(newline);

% Example with 1 component
disp('## Example with 1 component (which hold most of the information: ##');
[~,accOneFeat,foldsOneFeat,foldsSTDOneFeat,stdRunsOneFeat,trainFoldAccOneFeat,trainFoldSTDOneFeat,trainAccOneFeat] =...
    custom_classifier(projectedData(:,1),numTrials,rightIndicator,runs,kfold,bias);
disp(['Run #' num2str(runs) ' Accuracy (training): ' num2str(1-mean(trainFoldAccOneFeat)) '%' '   SD: ' num2str(trainFoldSTDOneFeat)]);
disp(['Run #' num2str(runs) ' Accuracy (validation): ' num2str(1-mean(foldsOneFeat)) '%' '   SD: ' num2str(foldsSTDOneFeat)]);
disp(['1-component model accuracy (training): ' num2str(100*mean(1-trainAccOneFeat)) '%' '   SD: ' num2str(std(trainAccOneFeat))]);
disp(['1-component model accuracy (validation): ' num2str(100*accOneFeat) '%' '   SD: ' num2str(stdRunsOneFeat)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Prediction
disp(newline);
disp('Testing:');
test_P_C_S = load('motor_imagery_test_data_full.mat');

testData = test_P_C_S.P_C_S.data(:,:,1:2);
% %use all train data for testing 
% testFeatures = get_features(testData,C3Bands,C3TimesSmp,C4Bands,C4TimesSmp,C3DiffC4Bands,C3DiffC4TimesSmp,imageryStart,imageryEnd,size(testData,1),welchWindow,noverlap,freqVec,fs);
% testProjectedData = (testFeatures-mean(features,1))*pcaCoeff;
% 
% %Predictions = classify(testFeatures,features,P_C_S.attribute(4,:)); % 1 = 'right' trial
% Predictions = classify(testProjectedData,projectedData,P_C_S.attribute(4,:)); % 1 = 'right' trial
% test_accuracy = sum(Predictions == test_P_C_S.P_C_S.attribute(4,:)')/size(testData,1);
% disp(['Test accuracy: ' num2str(100*test_accuracy) '%']);

for iTestTrial=1:size(testData,1)
    testFeatures = get_features(testData(iTestTrial,:,:),C3Bands,C3TimesSmp,C4Bands,C4TimesSmp,C3DiffC4Bands,C3DiffC4TimesSmp,imageryStart,imageryEnd,1,welchWindow,noverlap,freqVec,fs);
    testProjectedData = (testFeatures-mean(features,1))*pcaCoeff;
    Prediction = classify(testProjectedData,projectedData,P_C_S.attribute(4,:)); % 1 = 'right' trial
    disp(['test trial #' num2str(iTestTrial) ':  ' test_P_C_S.P_C_S.attributename{test_P_C_S.P_C_S.attribute(4,iTestTrial)+3}...
        ',   prediction:  ' test_P_C_S.P_C_S.attributename{Prediction+3}]);
    pause(0.5);  
end
