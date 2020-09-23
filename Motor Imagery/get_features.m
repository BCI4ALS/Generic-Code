function [features] = get_features(data,C3Bands,C3Times,C4Bands,C4Times,C3DiffC4Bands,C3DiffC4Times,imageryStart,imageryEnd,numTrials,window,noverlap,frequencies,fs)
%GET_FEATURES extracts features from the data for classification for each electrode individually and for the difference between electrodes.
%   bands and times for C3 and C4 electrodes are in @C3Bands, @C4Bands and @C3Times, C4Times
%   respectively. times and bands for the difference are in @C3DiffC4Times and @C3DiffC4Bands respectively.
%   @imageryStart and @imageryEnd indicate the
%   starting and ending times of visual imagery. @numTrials - number of
%   trials. @window, @noverlap, @fs are parameters for pwelch function (window
%   size, overlap size and sampling rate respectively). @frequencies is the
%   frequency vector.

%% memory allocation

freqC3 = zeros(numTrials,size(C3Bands,2)); % C3 relative band log power 
freqC4 = zeros(numTrials,size(C4Bands,2)); % C4 relative band log power 
rootTotalPowerC3 = zeros(numTrials,1); % C3 root total power
rootTotalPowerC4 = zeros(numTrials,1); % C4 root total power
spectralMomentC3 = zeros(numTrials,1); % C3 spectralMoment
spectralMomentC4 = zeros(numTrials,1); % C4 spectral moment
spectralEntropyC3 = zeros(numTrials,1); % C3 spectral entropy
spectralEntropyC4 = zeros(numTrials,1); % C4 spectral entropy


%% feature extraction

for i = 1:numTrials
    %% C3 features
    
    welchC3 = pwelch(data(i,imageryStart:imageryEnd,1),window,noverlap,frequencies,fs); % pwelch for C3 data
    C3band1 = welchC3(frequencies >= C3Bands{1,1}(1) & frequencies <= C3Bands{1,1}(2)); % first band
    C3band2 = welchC3(frequencies >= C3Bands{1,2}(1) & frequencies <= C3Bands{1,2}(2)); % second band
    C3band3 = welchC3(frequencies >= C3Bands{1,3}(1) & frequencies <= C3Bands{1,3}(2)); % third band
    rootTotalPowerC3(i) = sqrt(sum(welchC3));
    probC3 = welchC3./sum(welchC3);
    spectralMomentC3(i) = sum(sum(probC3.*frequencies'));
    spectralEntropyC3(i) = -(sum(probC3.*log2(probC3)));
    
    
    % relative log power calculation for chosen bands
    logPowerC3 = 10*log10(exp(1).*welchC3./min(welchC3));
    freqC3(i,1) = sum(10*log10(exp(1).*C3band1./min(C3band1)))./sum(logPowerC3);
    freqC3(i,2) = sum(10*log10(exp(1).*C3band2./min(C3band2)))./sum(logPowerC3);
    freqC3(i,3) = sum(10*log10(exp(1).*C3band3./min(C3band3)))./sum(logPowerC3);
    
    %% C4 features
    
    welchC4 = pwelch(data(i,imageryStart:imageryEnd,2),window,noverlap,frequencies,fs); % pwelch for C4 data
    C4band1 = welchC4(frequencies >= C4Bands{1,1}(1) & frequencies <= C4Bands{1,1}(2)); % first band
    C4band2 = welchC4(frequencies >= C4Bands{1,2}(1) & frequencies <= C4Bands{1,2}(2)); % second band
    C4band3 = welchC4(frequencies >= C4Bands{1,3}(1) & frequencies <= C4Bands{1,3}(2)); % third band
    rootTotalPowerC4(i) = sqrt(sum(welchC4));
    probC4 = welchC4./sum(welchC4);
    spectralMomentC4(i) = sum(sum(probC4.*frequencies'));  
    spectralEntropyC4(i) = -(sum(probC4.*log2(probC4)));
    
    % relative log power for chosen bands 
    logPowerC4 = 10*log10(exp(1).*welchC4./min(welchC4));
    freqC4(i,1) = sum(10*log10(exp(1).*C4band1./min(C4band1)))./sum(logPowerC4);
    freqC4(i,2) = sum(10*log10(exp(1).*C4band2./min(C4band2)))./sum(logPowerC4);
    freqC4(i,3) = sum(10*log10(exp(1).*C4band3./min(C4band3)))./sum(logPowerC4);
 
end

%% pure bands features (no pwelch)

C3diffC4 = abs(data(:,:,1) - data(:,:,2)); % subtract C4 from C3 to remove intersected data so that we'll have only the difference between the electrodes
featsC3diffC4 = cut_bands_by_times(C3diffC4,C3DiffC4Bands,C3DiffC4Times,numTrials,fs);
featsC3diffC4sqrt = sqrt(featsC3diffC4);
%  featsC3diffC4log = log(featsC3diffC4);

% C3 features
featsC3 = cut_bands_by_times(data(:,:,1),C3Bands,C3Times,numTrials,fs);
featsC3sqrt = sqrt(featsC3);
featsC3log = log(featsC3);


% C4 features
featsC4 = cut_bands_by_times(data(:,:,2),C4Bands,C4Times,numTrials,fs);
featsC4sqrt = sqrt(featsC4);
featsC4log = log(featsC4);




features = [ featsC3 featsC4  freqC3 freqC4 featsC3log featsC4log featsC3diffC4sqrt featsC4sqrt featsC3sqrt rootTotalPowerC3 rootTotalPowerC4 spectralMomentC3 spectralMomentC4 spectralEntropyC3 spectralEntropyC4];
end

