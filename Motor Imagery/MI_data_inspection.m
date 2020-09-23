% Visual inspection of Motor Imaginary data to help define features
%
% This code is part of the BCI-4-ALS Course written by Daniel Polyakov
% (polydani@post.bgu.ac.il) in 2020. You are free to use, change, adapt and
% so on - but please cite properly if published.
%
function MI_data_inspection()

%Local parameters
trainMiDataFname = 'motor_imagery_train_data.mat';
nTrialsToPlot = 20;
labelsCompareText = {'Left','Right'}; %pair of labels (conditions) for spectral comparison

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Electrodes and brain areas 
figure;
subplot(1,2,1);imshow('motor_cortex.jpg');title('Motor Cortex');
subplot(1,2,2);imshow('electrode_map.png');title('Electrodes Locations');

%% Load motor imagery Data
MIeeg = load_mi_data(trainMiDataFname);
% [nTrials, nSamples, nChannels] = size(MIeeg.data);

%% Time Series Visualization
for iLabel = 1:length(MIeeg.labelsText)
    trialInx = find(MIeeg.labels == iLabel);
    trialInx = trialInx(randperm(length(trialInx),nTrialsToPlot)); %chose randomly few trials
    plot_time_series(MIeeg, MIeeg.labelsText{iLabel}, trialInx);
end

%% Power Spectrum and Spectrogram
for iElec = 1:length(MIeeg.elecNames)
    plot_spectrum(MIeeg, iElec, labelsCompareText);
    plot_spectrogram(MIeeg, iElec, labelsCompareText);
end
