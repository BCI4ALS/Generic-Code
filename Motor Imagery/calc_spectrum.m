function [pwelchLeft,pwelchRight] = calc_spectrum(leftData,rightData,numChannels,numTrials,frequencies,window,noverlap,fs)
%CALC_SPECTRUM calculates pwelch spectrogram using calc_pwelch_by_sides and
%splits the result into left data (@pwelchLeft) and right data
%(pwelchRight).
%   @leftData - data from "left" trials. @rightData - data from "right" trials. @numChannels - number of channels
%   @numTrials - number of trials. @frequencies - frequency vector. @window, @noverlap window and overlap sizes for pwelch
%   @fs - sampling rate.
pwelchResult = calc_pwelch_by_sides(leftData,rightData,numChannels,numTrials/2,frequencies,window,noverlap,fs);
pwelchLeft = squeeze(pwelchResult(1,:,:));
pwelchRight = squeeze(pwelchResult(2,:,:));

end