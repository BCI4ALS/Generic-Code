% Plots time series (all channels of specified trials)
%
% inputs:
%   MIeeg
%   superTitle - this string is added to sgtitle 
%   trialInx - trial indeces to plot
%
% This code is part of the BCI-4-ALS Course written by Daniel Polyakov
% (polydani@post.bgu.ac.il) in 2020. You are free to use, change, adapt and
% so on - but please cite properly if published.
%
function plot_time_series(MIeeg, superTitle, trialInx)

%Local parameters
nColSubplots = 5;
%%%%%

nRowSubplots = ceil(length(trialInx)/nColSubplots);
t = 0:1/MIeeg.fs:(size(MIeeg.data,2)-1)/MIeeg.fs;

figure; 
sgtitle([superTitle ' imagining. MI happens from second ' num2str(MIeeg.imaginPeriodSec(1)) ' to second ' num2str(MIeeg.imaginPeriodSec(2))]);
for nPlot = 1:length(trialInx)
    subplot(nRowSubplots,nColSubplots,nPlot);
    plot(t,squeeze(MIeeg.data(trialInx(nPlot),:,:)));
    if nPlot > (nRowSubplots-1)*nColSubplots
        xlabel('sec');
    end
    if mod(nPlot,nColSubplots)==1
        ylabel(MIeeg.units);
    end
end
L = legend(MIeeg.elecNames);
set(L,'Position', [0.92 0.85 0.06 0.06],'Units', 'normalized');
