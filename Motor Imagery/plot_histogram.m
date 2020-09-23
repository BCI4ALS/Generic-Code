% Plots features histograms for a pair of conditions (labels)
%
% inputs:
%   features
%   featureNames
%   featureNamesPlot - requested features names
%   MIeeg
%   labelsCompareText - pair of labels (strings) to compare
%
% This code is part of the BCI-4-ALS Course written by Daniel Polyakov
% (polydani@post.bgu.ac.il) in 2020. You are free to use, change, adapt and
% so on - but please cite properly if published.
%
function plot_histogram(features, featureNames, featureNamesPlot, MIeeg, labelsCompareText)

%Local parameters
nColSubplots = 5;
%%%%%

featuresInx = find(contains(featureNames,featureNamesPlot));

labelsInx = find(contains(MIeeg.labelsText,labelsCompareText));
if length(labelsInx) ~=2
    warning('Please provide a pair of valid labels');
    return;
end

nRowSubplots = ceil(length(featuresInx)/nColSubplots);

figure; 
sgtitle('Features Histograms');
for nPlot = 1:length(featuresInx)
    subplot(nRowSubplots,nColSubplots,nPlot);
    hold on;
    histogram(features(MIeeg.labels == labelsInx(1),featuresInx(nPlot)));
    histogram(features(MIeeg.labels == labelsInx(2),featuresInx(nPlot)));
    hold off;
    title(featureNames{featuresInx(nPlot)});
    legend(labelsCompareText);
end
