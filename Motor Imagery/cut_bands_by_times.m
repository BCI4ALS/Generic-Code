function [features] = cut_bands_by_times(data,bands,times,numTrials,fs)
%CUT_BANDS_BY_TIMES extracts frequency bands and times according to @bands
%and @times from @data.

features = zeros(numTrials,size(bands,2));
for i = 1:size(bands,2)
    feat = zeros(numTrials,1);
    for j = 1:numTrials
        feat(j) = bandpower(data(j,times{1,i}),fs,bands{1,i});
    end
    features(:,i) = feat;
end
      
end


