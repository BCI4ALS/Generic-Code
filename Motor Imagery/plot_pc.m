% Plots principle components in 2d and 3d
%
% inputs:
%   components
%   MIeeg
%   labelsCompareText - pair of labels (strings) to compare
%
% This code is part of the BCI-4-ALS Course written by Daniel Polyakov
% (polydani@post.bgu.ac.il) in 2020. You are free to use, change, adapt and
% so on - but please cite properly if published.
%
function plot_pc(components, MIeeg, labelsCompareText)

if size(components,1) < 3
    warning('Please provide at least 3 components');
    return;
end

labelsInx = find(contains(MIeeg.labelsText,labelsCompareText));
if length(labelsInx) ~=2
    warning('Please provide a pair of valid labels');
    return;
end

figure;
sgtitle('Primary Components');
% 2D plot
subplot(1,2,1);
hold on;
scatter(components(MIeeg.labels == labelsInx(1),1),components(MIeeg.labels == labelsInx(1),2),'filled');
scatter(components(MIeeg.labels == labelsInx(2),1),components(MIeeg.labels == labelsInx(2),2),'filled');
hold off;
xlabel('PC1'); ylabel('PC2');
legend(labelsCompareText);
grid on;
axis square;

% 3D plot
subplot(1,2,2)
hold on;
scatter3(components(MIeeg.labels == labelsInx(1),1),components(MIeeg.labels == labelsInx(1),2),components(MIeeg.labels == labelsInx(1),3),'filled');
scatter3(components(MIeeg.labels == labelsInx(2),1),components(MIeeg.labels == labelsInx(2),2),components(MIeeg.labels == labelsInx(2),3),'filled');
hold off;
xlabel('PC1'); ylabel('PC2');xlabel('PC3');
legend(labelsCompareText);
grid on;
axis square;
view(40,35);
