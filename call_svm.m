function [risk, confusionMatrix] = ...
    call_svm(trainingData, testData, numStraps)

%for i = numStraps:-1:1
%    current_model = svmtrain(trainingData(i).x,trainingData(i).y);
%end

% scale data
trainingData.x = zscore(trainingData.x);
testData.x = zscore(testData.x);

% train model
current_model = svmtrain(trainingData.y, trainingData.x, '-q');

% make predictions
[predicted_label, acc, ~] = svmpredict(testData.y, testData.x, current_model);

% compute confusion matrix
confusionMatrix = confusionmat(testData.y, predicted_label);

% classification accuracy
SVMaccuracy = acc(1);

% risk?
risk = (100 - SVMaccuracy) / 100;


end

