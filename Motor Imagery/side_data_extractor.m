function [data] = side_data_extractor(rawData,indicators,numTrials,numSamples,numChannels,imageryStart,imageryEnd)
%SIDE_DATA_EXTRACTOR extracts data for @numTrials for a specific side (left/right) from
%@rawData, using @indicators to know which rows to extract. extracts data
%from @imageryStart time point to @imageryEnd time point. @numSamples - total samples.


numSideTrials = sum(indicators); % number of trials for current side
data = NaN(numSideTrials, numSamples, numChannels);
row = 1;
for i = 1:numTrials
    if indicators(i) == 1
        data(row,:,1:numChannels) = rawData(i,:,1:numChannels);
        row = row + 1;
    end
end

data = data(:,imageryStart:imageryEnd,:);

end
