% Train calssifier and save classifieer relevant data
% The purpose of this function is improving features and parameters to achieve 
% better classificaton accuracy
%
% inputs:
%   plotFlag
%
% This code is part of the BCI-4-ALS Course written by Daniel Polyakov
% (polydani@post.bgu.ac.il) in 2020. You are free to use, change, adapt and
% so on - but please cite properly if published.
%
function MI4_training_scaffolding(plotFlag)

if nargin == 0
    plotFlag = true;
end

%Local parameters
trainMiDataFname = 'motor_imagery_train_data.mat';
trainMiClassifierFname = 'motor_imagery_classifier.mat';
labelsCompareText = {'Left','Right'}; %pair of labels (conditions) for spectral comparison
%
% Modify these parameters to achieve better classification
nPcaComponents = 8; %at least 3 to avoid visualization error
classComponentsFlag = true; %use components to classifier input instead of features
%%

%% Load motor imagery Data
MIeeg = load_mi_data(trainMiDataFname);
% [nTrials, nSamples, nChannels] = size(MIeeg.data);

%% Extract features
[features, featureNames] = get_features(MIeeg);
if plotFlag
    plot_histogram(features, featureNames, ...
       {'C3bndpwr1','C4bndpwr3','C3bndpwrDB2','C4bndpwrDB2','C4spectralEntropy','C3spectralEntropy'},...
       MIeeg, labelsCompareText);    
end

%% PCA for dimensionality reduction and visualization
[pcaCoeff, components, ~] = pca(features, 'NumComponents',nPcaComponents);
if plotFlag
    plot_pc(components, MIeeg, labelsCompareText);
end

%% Classification with cross-validation
if classComponentsFlag
    [Model, fullAcc, cvMean, cvStd] = cv_classify(components, MIeeg);
else
    [Model, fullAcc, cvMean, cvStd] = cv_classify(features, MIeeg);
end
disp(newline);
disp(['All data classification model accuracy: ' num2str(fullAcc*100) '%']);
disp(['Cross-validation model accuracy: ' num2str(cvMean*100) '+-' num2str(cvStd*100) '%']);

%% Save classifier relevant data
labels = MIeeg.labels;
save(trainMiClassifierFname, 'Model', 'features', 'featureNames', 'components', 'pcaCoeff', 'classComponentsFlag', 'labels');
