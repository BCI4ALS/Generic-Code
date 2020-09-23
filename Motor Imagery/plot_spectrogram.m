% Plots average spectrogram (amplitude) for a pair of conditions (labels)
% as well as the relative power between them
%
% inputs:
%   MIeeg
%   elecInx - desired electrode inex
%   labelsCompareText - pair of labels (strings) to compare
%
% This code is part of the BCI-4-ALS Course written by Daniel Polyakov
% (polydani@post.bgu.ac.il) in 2020. You are free to use, change, adapt and
% so on - but please cite properly if published.
%
function plot_spectrogram(MIeeg, elecInx, labelsCompareText)

%Local parameters
window = round(0.3*MIeeg.fs);
noverlap = round(window/2);
%%%%%

labelsInx = find(contains(MIeeg.labelsText,labelsCompareText));
if length(labelsInx) ~=2
    warning('Please provide a pair of valid labels');
    return;
end

for iTrial = 1:size(MIeeg.data,1)
    [sxx(iTrial,:,:), f, t] = spectrogram(MIeeg.data(iTrial,:,elecInx)',window,noverlap,[],MIeeg.fs);
end

sxxMeanFirst = [];
caxisLim = [inf -inf];
figure; 
ax = [];
for iLabel = 1:2
    sxxMean = squeeze(mean(abs(sxx(MIeeg.labels == labelsInx(iLabel),:,:)),1)); %also try trimmean or median
    if isempty(sxxMeanFirst)
        sxxMeanFirst = sxxMean;
    end
    caxisLim = [min([min(sxxMean) caxisLim(1)]) max([max(sxxMean) caxisLim(2)])];
    ax(iLabel) = subplot(1,3,iLabel);
    imagesc(t,f,sxxMean);colorbar;
    xlabel('sec');ylabel('Hz');
    title([MIeeg.elecNames{elecInx} ' mean energy spectrogram: ' MIeeg.labelsText{iLabel}]);
end
for iLabel = 1:2
    caxis(ax(iLabel),caxisLim); %set colorbar limit
end

subplot(1,3,3);
imagesc(t,f,10*log10(sxxMean./sxxMeanFirst));colorbar;
xlabel('sec');ylabel('Hz');
title([MIeeg.elecNames{elecInx} ' relative power [dB] ' labelsCompareText{2} '/' labelsCompareText{1} ': ' MIeeg.labelsText{iLabel}]);
