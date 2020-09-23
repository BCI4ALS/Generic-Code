function [] = SSVEP4_ExtractFeatures_Scaffolding(recordingFolder)
%% This function extracts features for the machine learning process.
% It takes the segmented data and extracts the power in each stim frequency and labels
% into a variable which is fed into a modeling function.

% This code is part of the BCI-4-ALS Course written by Asaf Harel
% (harelasa@post.bgu.ac.il) in 2020. You are free to use, change, adapt and
% so on - but please cite properly if published.

%% Load previous variables:
load(strcat(recordingFolder,'sessionFreqs.mat'));                   % load the original training frequencies
load(strcat(recordingFolder,'conditionFreq.mat'));                  % load the original target frequencies
numTargets = length(unique(sessionFreqs));                          % figure out how many targets from unique frequencies
load(strcat(recordingFolder,'EEG_chans.mat'));                      % load the openBCI channel locations
features = unique(sessionFreqs);                                    % methodological name change

%%%%%%%%%%%% INSERT NOVEL FEATURES HERE %%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numFeatures = length(features);                                     % how many features overall exist

save(strcat(recordingFolder,'features.mat'),'features');            % save the bastards
load(strcat(recordingFolder,'SSVEPData.mat'));                      % load the EEG data

Fs = 125;                                                           % openBCI Cyton+Daisy by Bluetooth sample rate
trials = size(SSVEPData,1);                                         % get number of trials from main data variable
[R, C] = size(EEG_chans);                                           % get EEG_chans (char matrix) size - rows and columns
chanLocs = reshape(EEG_chans',[1, R*C]);                            % reshape into a vector in the correct order
occipital1Index = strfind(chanLocs,'O01');                          % find first occipital channel
occipital1Index = ceil(occipital1Index/C);                          % index of O01 channel
occipital2Index = strfind(chanLocs,'O02');                          % find second occipital channel
occipital2Index = ceil(occipital2Index/C);                          % index of O02 channel
occipitalData = SSVEPData(:,[occipital1Index occipital2Index],:);   % only use the occipital channels (O1 & O2)
clear SSVEPData occipital1Index occipital2Index chanLocs R C
numChans = size(occipitalData,2);                                   % get number of channels from main data variable

SSVEPFeaturesLabel = NaN(trials,numChans,numFeatures);            % init features+labels matrix

for targ = 1:numTargets
    targetLabels(sessionFreqs == conditionFreq(targ)) = targ;       % create the label according to the session used in each trial
end

%% Extract features (powerbands in alpha, beta, delta, theta, gamma bands)
for trial = 1:trials
    for channel = 1:numChans
        for feature = 1:numFeatures
            % Extract features: bandpower +-1 Hz around each target frequency
            SSVEPFeaturesLabel(trial,channel,feature) = bandpower(squeeze(occipitalData(trial,channel,:)),Fs,[features(feature)-1,features(feature)+1]);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%% INSERT NOVEL FEATURES HERE %%%%%%%%%%%%%%%%%%
        %%% i.e. connectivity, Riemannian Geometry, entropy..%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end
% Reshape into 2-D matrix
SSVEPFeaturesLabel = reshape(SSVEPFeaturesLabel,trials,[]);
% Append labels (stimulated frequency or condition)
SSVEPFeaturesLabel = [SSVEPFeaturesLabel targetLabels'];
end
% Export variable into CSV file
writematrix(SSVEPFeaturesLabel,strcat(recordingFolder,'SSVEPFeaturesLabel.csv'));


end
