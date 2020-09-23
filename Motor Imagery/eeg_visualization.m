function [] = eeg_visualization(data, name, numSubplots, t, fontSize, imageryStart, imageryEnd)
%EEG_VISUALIZATION visualizes the EEG signal in a single channel for trials from a single class. 
%   draws a figure with @numSubplots for each class (left and right) corresponding to @numSubplots random trials.
%   Each subplot plots the data from both channels (C3 and C4).
%   @name - sgtitle name. @t - time vector. @imageryStart and @imageryEnd - start and finish points for visual imagery.

%% figure styling
handle = figure; 
titleSize = fontSize + 10;
set(handle,'Color','w');
set(handle,'units','normalized');
set(handle,'outerposition',[0 0 0.9 0.9]);

ylabels = 1:4:17;
xlables = 17:numSubplots;

h = sgtitle(name);
set(h,'FontSize',titleSize);

%% plotting 

for i = 1:numSubplots
    subplot(5,4,i); hold on;
    xlim([t(imageryStart) t(imageryEnd)]); 
    ylim([-20 20]);
    title(['Trial #', num2str(i)]);
    box on;
    plot(t(imageryStart:imageryEnd),data(i,:,1),'DisplayName','Channel C3', 'Color', 'r');
    plot(t(imageryStart:imageryEnd),data(i,:,2),'DisplayName','Channel C4', 'Color', 'b');
    if ismember(i,xlables)
        xlabel('Time (sec)', 'FontSize', fontSize);
    end
    if ismember(i,ylabels)
        ylabel('Signal (uV)', 'FontSize', fontSize);
    end
    set(gca,'FontSize',fontSize);
    
end

R = legend('show');
newPosition = [0.9 0.91 0.06 0.06];
newUnits = 'normalized';
set(R,'Position', newPosition,'Units', newUnits);






end

