function [risk, confusionMatrix] = call_NearestNeighbor(trainingData, testData, k)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
trainingData.x = zscore(trainingData.x);
testData.x = zscore(testData.x);
model = ClassificationKNN.fit(trainingData.x,trainingData.y, 'NumNeighbors', k);
yHat = model.predict(testData.x);
risk = mean(abs(testData.y-yHat));
confusionMatrix = confusionmat(testData.y,yHat);

end

