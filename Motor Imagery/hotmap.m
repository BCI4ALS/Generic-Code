function [] = hotmap(rightDataAll,leftDataAll,numTrials,noverlap,fs)
%HOTMAP displays time(sec)/frequency(Hz) energy heatmaps for "right" and "left" trials seprately, as well
%as for the different electrodes and the difference between them.
%   @numTrials is the amount of trials. @noverlap is the overlap for
%   spectrogram function, @fs is the sampling rate.
%   uses 'spectrogram to get the spectral density for each trial and then
%   displays the average of the heatmaps in each subplot.



spectrogramFreqs = 4:0.1:40; % started at 4 Hz because the lower frequencies aren't as informative. [Hz]
figure;

%% C3 heatmap

% C3 Right side
[~, rightFrequencyVector, rightTimeVector, rightSpectralDensity] = spectrogram(rightDataAll(1,:,1),numTrials/2,noverlap,spectrogramFreqs,fs,'yaxis');
for i = 1:numTrials/2 - 1
   [~, frequencyVectorTemp, timeVectorTemp, spectralDensityTemp] = spectrogram(rightDataAll(i+1,:,1),numTrials/2,noverlap,spectrogramFreqs,fs,'yaxis');
   rightFrequencyVector = rightFrequencyVector + frequencyVectorTemp; %[Hz]
   rightTimeVector = rightTimeVector + timeVectorTemp; %[sec]
   rightSpectralDensity = rightSpectralDensity + spectralDensityTemp;
end
rightFrequencyVector = rightFrequencyVector/(numTrials/2); %[[Hz]
rightTimeVector = rightTimeVector/(numTrials/2); % [sec]
rightSpectralDensity = rightSpectralDensity/(numTrials/2);

subplot(3,2,1)
imagesc(rightTimeVector,rightFrequencyVector,rightSpectralDensity);
ylabel('Frequency [Hz]'); xlabel('Time[sec]');
title('C3 - Right')
colormap hot;
colorbar;


% C3 Left side
[~, leftFrquencyVector, leftTimeVector, leftSpectralDensity] = spectrogram(leftDataAll(1,:,1),numTrials/2,noverlap,spectrogramFreqs,fs,'yaxis');
for i = 1:numTrials/2 - 1
   [~, frequencyVectorTemp, timeVectorTemp, spectralDensityTemp] = spectrogram(leftDataAll(i+1,:,1),numTrials/2,noverlap,spectrogramFreqs,fs,'yaxis');
   leftFrquencyVector = leftFrquencyVector + frequencyVectorTemp; %[Hz]
   leftTimeVector = leftTimeVector + timeVectorTemp;%[sec]
   leftSpectralDensity = leftSpectralDensity + spectralDensityTemp;
end
leftFrquencyVector = leftFrquencyVector/(numTrials/2);%[Hz]
leftTimeVector = leftTimeVector/(numTrials/2); %[sec]
leftSpectralDensity = leftSpectralDensity/(numTrials/2);
subplot(3,2,3)
imagesc(leftTimeVector,leftFrquencyVector,leftSpectralDensity);
ylabel('Frequency [Hz]'); xlabel('Time[sec]');
title('C3 - Left')
colormap hot;
colorbar;


% C3 Diff
diffSpectralDensity = abs(rightSpectralDensity - leftSpectralDensity);
subplot(3,2,5)
imagesc(leftTimeVector,leftFrquencyVector,diffSpectralDensity);
ylabel('Frequency [Hz]'); xlabel('Time[sec]');
title('C3 - Diff')
colormap hot;
colorbar;

%% C4 heatmap

% C4 Right side
[~, rightFrequencyVector, rightTimeVector, rightSpectalDensity] = spectrogram(rightDataAll(1,:,2),numTrials/2,noverlap,spectrogramFreqs,fs,'yaxis');
for i = 1:numTrials/2 - 1
   [~, frequencyVectorTemp, timeVectorTemp, spectralDensityTemp] = spectrogram(rightDataAll(i+1,:,2),numTrials/2,noverlap,spectrogramFreqs,fs,'yaxis');
   rightFrequencyVector = rightFrequencyVector + frequencyVectorTemp; %[Hz]
   rightTimeVector = rightTimeVector + timeVectorTemp; % [sec]
   rightSpectalDensity = rightSpectalDensity + spectralDensityTemp;
end
rightFrequencyVector = rightFrequencyVector/(numTrials/2); %[Hz]
rightTimeVector = rightTimeVector/(numTrials/2); %[sec]
rightSpectalDensity = rightSpectalDensity/(numTrials/2);

subplot(3,2,2)
imagesc(rightTimeVector,rightFrequencyVector,rightSpectalDensity);
ylabel('Frequency [Hz]'); xlabel('Time[sec]');
title('C4 - Right')
colormap hot;
colorbar;


% C4 Left side
[~, leftFrequencyVector, leftTimeVector, leftSpectralDensity] = spectrogram(leftDataAll(1,:,2),numTrials/2,noverlap,spectrogramFreqs,fs,'yaxis');
for i = 1:numTrials/2 - 1
   [~, frequencyVectorTemp, timeVectorTemp, spectralDensityTemp] = spectrogram(leftDataAll(i+1,:,1),numTrials/2,noverlap,spectrogramFreqs,fs,'yaxis');
   leftFrequencyVector = leftFrequencyVector + frequencyVectorTemp; %[Hz]
   leftTimeVector = leftTimeVector + timeVectorTemp; %[sec]
   leftSpectralDensity = leftSpectralDensity + spectralDensityTemp;
end
leftFrequencyVector = leftFrequencyVector/(numTrials/2); %[Hz]
leftTimeVector = leftTimeVector/(numTrials/2); %[sec]
leftSpectralDensity = leftSpectralDensity/(numTrials/2);
subplot(3,2,4)
imagesc(leftTimeVector,leftFrequencyVector,leftSpectralDensity);
ylabel('Frequency [Hz]'); xlabel('Time[sec]');
title('C4 - Left')
colormap hot;
colorbar;


% C4 Diff
diffSpectralDensity = abs(rightSpectalDensity - leftSpectralDensity);
subplot(3,2,6)
imagesc(leftTimeVector,leftFrequencyVector,diffSpectralDensity);
ylabel('Frequency [Hz]'); xlabel('Time[sec]');
title('C4 - Diff')
colormap hot;
colorbar;

sgtitle('Energy heatmaps');
end

