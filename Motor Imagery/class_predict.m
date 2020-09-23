% Classifier prediction
% Currently LDA classifier is implemented. 
% Consider replacig this classifier with a better one
%
% inputs:
%   Model - classifier model
%   X - data observations to classify
%   components - needed for LDA
%   labels - needed for LDA
% outputs:
%   y - model predictions
%   xErr - error of 'components-labels' classification by LDA
%
% This code is part of the BCI-4-ALS Course written by Daniel Polyakov
% (polydani@post.bgu.ac.il) in 2020. You are free to use, change, adapt and
% so on - but please cite properly if published.
%
function [y, xErr] = class_predict(Model, X, components, labels)

[y, xErr] = classify(X,components,labels);
