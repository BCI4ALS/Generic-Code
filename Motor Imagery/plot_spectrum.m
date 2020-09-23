% Plots average power spectrum (welch psd) of Motor Imagery Period for a
% pair of conditions (labels) as well as the relative power between them
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
function plot_spectrum(MIeeg, elecInx, labelsCompareText)

%Local parameters
window = round(1.5*MIeeg.fs);
noverlap = round(window/2);
%%%%%

labelsInx = find(contains(MIeeg.labelsText,labelsCompareText));
if length(labelsInx) ~=2
    warning('Please provide a pair of valid labels');
    return;
end

imaginPeriodSmp = 1:size(MIeeg.data,2);
imaginPeriodSmp = imaginPeriodSmp(imaginPeriodSmp>=MIeeg.imaginPeriodSec(1)*MIeeg.fs & ...
    imaginPeriodSmp<=MIeeg.imaginPeriodSec(2)*MIeeg.fs);
[pxx, f] = pwelch(MIeeg.data(:,imaginPeriodSmp,elecInx)',window,noverlap,[],MIeeg.fs);

pxxMeanFirst = [];
lineSubset = [];
figure; 
subplot(1,2,1); %plot mean with confidence intervals of 1 STD
hold on;
for iLabel = 1:2
    pxxMean = mean(pxx(:,MIeeg.labels == labelsInx(iLabel)),2); %also try trimmean or median
    if isempty(pxxMeanFirst)
        pxxMeanFirst = pxxMean;
    end
    pxxStd = std(pxx(:,MIeeg.labels == labelsInx(iLabel)),[],2);
    pxxHighStd = pxxMean+pxxStd;
    pxxLowStd = pxxMean-pxxStd;
    lineSubset(iLabel) = plot(f,pxxMean);
    lineColor = get(lineSubset(iLabel), 'Color');
    plot(f,pxxHighStd,'-.','Color',lineColor);
    plot(f,pxxLowStd,'-.','Color',lineColor); 
    fill([f; flip(f)], [pxxHighStd; flip(pxxLowStd)], lineColor); 
    alpha(0.2) %transperacy
end
hold off; 
xlabel('Hz'); ylabel([MIeeg.units '^2 / Hz']);
title([MIeeg.elecNames{elecInx} ' mean welch spectrum']);
legend(lineSubset,MIeeg.labelsText);

subplot(1,2,2);
plot(f,10*log10(pxxMean./pxxMeanFirst));
xlabel('Hz'); ylabel('dB');
title([MIeeg.elecNames{elecInx} ' relative power (welch) ' labelsCompareText{2} '/' labelsCompareText{1}]);
