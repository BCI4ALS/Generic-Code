% Trains a model to classify labeled observations (components or features) 
% Performs cross-validation
%
% inputs:
%   components - components or features matrix
%   MIeeg
% outputs:
%   Model - classifier model
%   fullAcc - model accuracy when all data is used
%   cvMean - model cross-validation average accuracy
%   cvStd - model cross-validation accuracy std
%
% This code is part of the BCI-4-ALS Course written by Daniel Polyakov
% (polydani@post.bgu.ac.il) in 2020. You are free to use, change, adapt and
% so on - but please cite properly if published.
%
function [Model, fullAcc, cvMean, cvStd] = cv_classify(components, MIeeg)


%Local parameters
kFolds = 5;
%%%%%

Model = []; %not needed in case of LDA
[~, xErr] = class_predict(Model, [], components, MIeeg.labels);
fullAcc = 1-xErr;

CVO = cvpartition(MIeeg.labels,'kfold',kFolds); % creates a cross-validation partition for data
xErrFold = [];
for iFld = 1:kFolds
    [~, xErrFold(iFld)] = class_predict(Model, components(CVO.test(iFld),:),...
        components(CVO.training(iFld),:), MIeeg.labels(CVO.training(iFld)));
end
cvMean = 1-mean(xErrFold);
cvStd = std(xErrFold);
