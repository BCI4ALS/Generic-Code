function [result] = calc_pwelch_by_sides(leftData,rightData,numChannels,numTrials,frequencies,window,noverlap,fs)
% CALC_PWELCH_BY_SIDES calculates the pwelch for each side, channel and trial and then
% averages the pwelch between trials to return a 3D matrix: 2x2xsize(frequencies)
%   @leftData - data from "left" trials. @rightData - data from "right" trials. @numChannels - number of channels
%   @numTrials - number of trials. @frequencies - frequency vector. @window, @noverlap window and overlap sizes for pwelch
%   @fs - sampling rate.


sidesNum = 2;
outliersCut = 1; % percent of outliers to remove from final result
freqsNum = length(frequencies);
tempData = NaN(sidesNum,numChannels,numTrials,freqsNum);
result = NaN(sidesNum,numChannels,freqsNum);
for i = 1:sidesNum
    for j = 1:numChannels
        for k = 1:numTrials
            if i == 2
                tempData(i,j,k,:) = pwelch(rightData(k,:,j),window,noverlap,frequencies,fs);
            else
                tempData(i,j,k,:) = pwelch(leftData(k,:,j),window,noverlap,frequencies,fs);
            end
        end
        result(i,j,:) = trimmean(tempData(i,j,:,:),outliersCut); % average over frequencies
    end
end

end