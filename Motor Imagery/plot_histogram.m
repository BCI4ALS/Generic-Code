function [] = plot_histogram(C3Bands,C4Bands,C3DiffC4Bands,rightData,leftData,fs)
%PLOT_HISTOGRAM plots energy histograms for @C3Bands and @C4Bands as well as @C3DiffC4Bands (C3-C4).
%   coloring @rightData and @leftData separately, to see the difference
%   between "left" trials and "right" trials. @fs is the sampling rate.


%% calculate C3 bandpowers

C3Range1Right = bandpower(rightData(:,:,1)',fs,C3Bands{1, 1});
C3Range1Left = bandpower(leftData(:,:,1)',fs,C3Bands{1, 1});

C3Range2Right = bandpower(rightData(:,:,1)',fs,C3Bands{1, 2});
C3Range2Left = bandpower(leftData(:,:,1)',fs,C3Bands{1, 2});

C3Range3Right = bandpower(rightData(:,:,1)',fs,C3Bands{1, 3});
C3Range3Left = bandpower(leftData(:,:,1)',fs,C3Bands{1, 3});


%% calculate C4 bandpowers

C4Range1Right = bandpower(rightData(:,:,2)',fs,C4Bands{1, 1});
C4Range1Left = bandpower(leftData(:,:,2)',fs,C4Bands{1, 1});

C4Range2Right = bandpower(rightData(:,:,2)',fs,C4Bands{1, 2});
C4Range2Left = bandpower(leftData(:,:,2)',fs,C4Bands{1, 2});

C4Range3Right = bandpower(rightData(:,:,2)',fs,C4Bands{1, 3});
C4Range3Left = bandpower(leftData(:,:,2)',fs,C4Bands{1, 3});


%% calculate C3-C4 bandpowers

diffRight = rightData(:,:,1) - rightData(:,:,2);
diffLeft = leftData(:,:,1) - leftData(:,:,2);

diffRange1Right = bandpower(diffRight,fs,C3DiffC4Bands{1, 1});
diffRange1Left = bandpower(diffLeft,fs,C3DiffC4Bands{1, 1});

diffRange2Right = bandpower(diffRight,fs,C3DiffC4Bands{1, 2});
diffRange2Left = bandpower(diffLeft,fs,C3DiffC4Bands{1, 2});

%% plotting histograms

figure('name','Energy','units','normalized','outerposition',[0 0 0.75 0.75]);

subplot(2,4,1);
histogram(C3Range1Right,'FaceColor',[0.6350 0.0780 0.1840]);
hold on;
histogram(C3Range1Left,'FaceColor',[0.3010 0.7450 0.9330]);
xlim([0 30]);
ylim([0 60]);
xlabel('Energy');
ylabel('count');
title(['C3 -', num2str(C3Bands{1, 1}(1)),'-',num2str(C3Bands{1, 1}(2)),'  [Hz]']);
legend("Right","Left");
hold off;

subplot(2,4,2);
histogram(C3Range2Right,'FaceColor',[0.6350 0.0780 0.1840]);
hold on;
histogram(C3Range2Left,'FaceColor',[0.3010 0.7450 0.9330]);
xlim([0 30]);
ylim([0 60]);
title(['C3 -', num2str(C3Bands{1, 2}(1)),'-',num2str(C3Bands{1, 2}(2)),'  [Hz]']);
xlabel('Energy');
ylabel('count');
legend("Right","Left");
hold off;

subplot(2,4,3);
histogram(C3Range3Right,'FaceColor',[0.6350 0.0780 0.1840]);
hold on;
histogram(C3Range3Left,'FaceColor',[0.3010 0.7450 0.9330]);
xlim([0 30]);
ylim([0 60]);
title(['C3 -', num2str(C3Bands{1, 3}(1)),'-',num2str(C3Bands{1, 3}(2)),'  [Hz]']);
xlabel('Energy');
ylabel('count');
legend("Right","Left");
hold off;


subplot(2,4,4);
histogram(diffRange1Right,'FaceColor',[0.6350 0.0780 0.1840]);
hold on;
histogram(diffRange1Left,'FaceColor',[0.3010 0.7450 0.9330]);
xlim([0 30]);
ylim([0 60]);
title(['C3 - C4 -', num2str(C3DiffC4Bands{1, 1}(1)),'-',num2str(C3DiffC4Bands{1, 1}(2)),'  [Hz]']);
xlabel('Energy');
ylabel('count');
legend("Right","Left");
hold off;


subplot(2,4,5);
histogram(C4Range1Right,'FaceColor',[0.6350 0.0780 0.1840]);
hold on;
histogram(C4Range1Left,'FaceColor',[0.3010 0.7450 0.9330]);
xlim([0 30]);
ylim([0 60]);
title(['C4 -', num2str(C4Bands{1, 1}(1)),'-',num2str(C4Bands{1, 1}(2)),'[HZ]']);
xlabel('Energy');
ylabel('count');
legend("Right","Left");
hold off;

subplot(2,4,6);
histogram(C4Range2Right,'FaceColor',[0.6350 0.0780 0.1840]);
hold on;
histogram(C4Range2Left,'FaceColor',[0.3010 0.7450 0.9330]);
xlim([0 30]);
ylim([0 60]);
title(['C4 -', num2str(C4Bands{1, 2}(1)),'-',num2str(C4Bands{1, 2}(2)),'  [Hz]']);
xlabel('Energy');
ylabel('count');
legend("Right","Left");
hold off;

subplot(2,4,7);
histogram(C4Range3Right,'FaceColor',[0.6350 0.0780 0.1840]);
hold on;
histogram(C4Range3Left,'FaceColor',[0.3010 0.7450 0.9330]);
xlim([0 30]);
ylim([0 60]);
title(['C4 -', num2str(C4Bands{1, 3}(1)),'-',num2str(C4Bands{1, 3}(2)),'  [Hz]']);
xlabel('Energy');
ylabel('count');
legend("Right","Left");
hold off;

subplot(2,4,8);
histogram(diffRange2Right,'FaceColor',[0.6350 0.0780 0.1840]);
hold on;
histogram(diffRange2Left,'FaceColor',[0.3010 0.7450 0.9330]);
xlim([0 30]);
ylim([0 60]);
title(['C3 - C4 -', num2str(C3DiffC4Bands{1, 2}(1)),'-',num2str(C3DiffC4Bands{1, 2}(2)),'  [Hz]']);
xlabel('Energy');
ylabel('count');
legend("Right","Left");
hold off;

sgtitle('Energy histograms for each interesting band by channel');
end

