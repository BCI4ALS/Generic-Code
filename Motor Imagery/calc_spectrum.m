function [pwelchLeft,pwelchRight] = calc_spectrum(leftData,rightData,numChannels,numTrials,freqVec,welchWindow,noverlap,fs)
%CALC_SPECTRUM calculates pwelch spectrogram using calc_pwelch_by_sides and
%splits the result into left data (@pwelchLeft) and right data
%(pwelchRight).
%   @leftData - data from "left" trials. @rightData - data from "right" trials. @numChannels - number of channels
%   @numTrials - number of trials. @freqVec - frequency vector. @welchWindow, @noverlap welchWindow and overlap sizes for pwelch
%   @fs - sampling rate.
pwelchResult = calc_pwelch_by_sides(leftData,rightData,numChannels,numTrials/2,freqVec,welchWindow,noverlap,fs);
pwelchLeft = squeeze(pwelchResult(1,:,:));
pwelchRight = squeeze(pwelchResult(2,:,:));

end