% Run online classification on testing data
%
% inputs:
%   onlineFlag - if true simulates trials one by one; if false returns
%   classification statistics of all data
%
% This code is part of the BCI-4-ALS Course written by Daniel Polyakov
% (polydani@post.bgu.ac.il) in 2020. You are free to use, change, adapt and
% so on - but please cite properly if published.
%
function MI_onlne_testing_scaffolding(onlineFlag)

if nargin == 0
    onlineFlag = true;
end

%Local parameters
testMiDataFname = 'motor_imagery_test_data.mat';
trainMiClassifierFname = 'motor_imagery_classifier.mat';
pauseSec = 0.5;
%

%% Load motor imagery Model and Test data
load(trainMiClassifierFname);
MIeegTest = load_mi_data(testMiDataFname);
% [nTrials, nSamples, nChannels] = size(MIeegTest.data);

%% Prediction
disp(newline);
if onlineFlag
    disp('Testing:');
    
    MIeegTestOnline = MIeegTest;
    for iTrial=1:size(MIeegTest.data,1)
        MIeegTestOnline.data = MIeegTest.data(iTrial,:,:);
        MIeegTestOnline.labels = MIeegTest.labels(iTrial);
        [testFeatures, ~] = get_features(MIeegTestOnline);
        if classComponentsFlag
            testComponents = (testFeatures-mean(features,1))*pcaCoeff;
            [y, ~] = class_predict(Model, testComponents, components, labels);
        else
            [y, ~] = class_predict(Model, testFeatures, features, labels);
        end
        disp(['test trial #' num2str(iTrial) ':  ' MIeegTestOnline.labelsText{MIeegTestOnline.labels}...
            ',   prediction:  ' MIeegTestOnline.labelsText{y}]);
        pause(pauseSec);
    end
else
    [testFeatures, ~] = get_features(MIeegTest);
    if classComponentsFlag
        testComponents = (testFeatures-mean(features,1))*pcaCoeff;
        [y, ~] = class_predict(Model, testComponents, components, labels);
    else
        [y, ~] = class_predict(Model, testFeatures, features, labels);
    end
    testAcc = sum(y == MIeegTest.labels')/length(y);
    disp(['Test accuracy: ' num2str(100*testAcc) '%']);
end
