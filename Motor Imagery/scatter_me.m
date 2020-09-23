function [] = scatter_me(PCs,rightIndicator,leftIndicator,fontSize)%t,patientID,seizureNum,PCs
%SCATTER_ME scatter plots the top 2 PCs and top 3 PCs in two subplots
%  @PCs = projected features data onto top PCs from PCA. @rightIndicator
%  and @leftIndicator are used to color the points in the scatter plot in
%  blue and red respectively


fg = figure;
hold on ;
set(fg, 'Name','Scatter plots','Color','w', 'Units','normalized', 'Position', [0 0.1 0.75 0.75]);
hold on;

% 2D plot
subplot(1,2,1);
scatter(PCs(rightIndicator>0,1),PCs(rightIndicator>0,2),round(0.85*fontSize),'filled','SizeData',2*fontSize,'MarkerFaceColor','b');
hold on
scatter(PCs(leftIndicator>0,1),PCs(leftIndicator>0,2),round(0.85*fontSize),'filled','SizeData',2*fontSize,'MarkerFaceColor','r');
xlabel ('PC1','FontSize',fontSize); 
ylabel ('PC2','FontSize',fontSize);
set(gca,'FontSize',fontSize);
title('2D Projection','fontweight','bold','fontsize',round(1.5*fontSize));
grid on;
axis square;

% 3D plot
subplot(1,2,2)
scatter3(PCs(rightIndicator>0,1),PCs(rightIndicator>0,2),PCs(rightIndicator>0,3),round(0.85*fontSize),'filled','SizeData',2*fontSize,'MarkerFaceColor','b');
hold on;
scatter3(PCs(leftIndicator>0,1),PCs(leftIndicator>0,2),PCs(leftIndicator>0,3),round(0.8*fontSize),'filled','SizeData',2*fontSize,'MarkerFaceColor','r');
xlabel ('PC1','FontSize',fontSize);
ylabel ('PC2','FontSize',fontSize); 
zlabel('PC3','FontSize',fontSize);
set(gca,'FontSize',fontSize);
title('3D Projection','fontweight','bold','fontsize',round(1.5*fontSize));
grid on;

axis square;
hold on;
sptitle = sgtitle('Left/Right Classificition');
set(sptitle,'fontsize',round(1.5*fontSize));
legend({'Right','Left'},'FontSize',fontSize, 'Position',[0.05, 0.8, 0, 0]);
hold off;


end
