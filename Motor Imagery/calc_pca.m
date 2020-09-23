function [X] = calc_pca(features,comNum,trialsNum)
%PCA manually calculate principal components analysis on @features matrix
%and returns the projection of the data on the top @comNum eigen vectors


Z = zscore(features,0,1);
meanSample = mean(Z,1); % Calculates the mean for each component
X = (Z - meanSample)'; % Substractes the mean from features
Cov = (X*X')./(trialsNum-1); % Calculate the Covariance matrix
[eVecs, ~] = eig(Cov); % extract eigen vectors
PCs = eVecs(:,length(eVecs):-1:length(eVecs)-comNum+1); % get top @comNum PCs
PCProjection = (PCs'*X)'; % project data onto PCs
X = PCProjection;

end

