function [prediction,accuracy,foldsAcc,foldsSTD,stdRuns,trainFoldAcc,trainFoldSTD,trainAcc] = custom_classifier(features,trialsNum,rightIndicator,runs,kfold,bias)
%CUSTOM_CLASSIFIER run @kfolds cross validation @runs times and saves the
%  average prediction in @prediction. also calculates @accuracy for the
%  average prediction and the standard deviation for the different runs accuracy(@stdRuns).
%  calculates accuracy and standard deviation for the
%  different folds of one run (@foldsAcc, @foldsSTD respectively).


%% Classification

y = rightIndicator; % target variable
answers = NaN(trialsNum,runs+1); % predictions for each trial and run 
trainFoldAcc = zeros(kfold,1); % accuracy for training for a specific run
trainAcc = zeros(runs,1); % accuracy for training for all the runs

for run = 1:runs
    CVO = cvpartition(y,'k',kfold); % creates a cross-validation partition for data.
    err = zeros(CVO.NumTestSets,1); % hols the errors for each run
    
    for i = 1:kfold
        trIdx = CVO.training(i); % training indices
        teIdx = CVO.test(i); % test indices
        [ytest, trainFoldAcc(i)] = classify(features(teIdx,:),features(trIdx,:),y(trIdx),'linear'); % prediction for current fold
        
        % calculate error for each trial in the fold
        for j = 1:CVO.TestSize(i)
            foldAnsers = y(teIdx)';
            err(i) = err(i)+ int8((ytest(j)~= foldAnsers(j)));
        end
        answers(find(teIdx),run) = ytest+bias; % adds manual bias (if one was defined in @bias)
    end
    trainAcc(run) = mean(trainFoldAcc);
end

foldsAcc = err./CVO.TestSize'; % accuracy for folds in the last run
foldsSTD = std(foldsAcc); % standard  deviation for folds in the last run
answers(:,runs+1) = ceil(mean(answers(:,1:runs)')); % average out the answers between runs. we chose to round up because our model is slightlybiased to say more 'left' than 'right


%% Accuracy calculation

errors = zeros(trialsNum,runs+1);
for j = 1:runs+1
    for i = 1:trialsNum
        errors(i,j) =  int8((answers(i,j)~= y(i)));
    end 
end

trainFoldSTD = std(trainFoldAcc);
stdRuns = std(sum(errors(:,1:runs))/trialsNum);
accuracy = 1 - sum(errors(:,runs+1))/trialsNum;
prediction = answers(:,runs+1);
end

