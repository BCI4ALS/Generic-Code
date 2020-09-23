function [] = plot_spectrum(pwelchRight,pwelchLeft,frequencies,numChannels,chanNames)
%PLOT_SPECTRUM plots a specific channels power spectra in a specific
% method, depends on the call of the function. Both sides are plotted for
% each channel called for plotting.

figure; 

for index = 1:numChannels
    
    % plot power spectra for both sides
    subplot(2,2,index); hold on; box on;
    title(['pwelch ', chanNames(index,:)]);
    plot(frequencies,pwelchRight(index,:));
    plot(frequencies,pwelchLeft(index,:));
    ylabel('Power'); xlabel('Frequency [Hz]');
    legend("Right","Left");
    
    % plot power spectra for diff
    subplot(2,2,index+2); hold on; box on;
    title(['diff ', chanNames(index,:)]);
    plot(frequencies,abs(pwelchRight(index,:)-pwelchLeft(index,:)),'color','g');
    ylabel('Power'); xlabel('Frequency [Hz]');
    legend("Diff");

end

sgtitle('Power spectra for each channel');

end

