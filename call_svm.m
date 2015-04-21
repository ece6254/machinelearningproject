function [risk, confusionMatrix] = call_svm(trainingData, testData, numStraps)

%for i = numStraps:-1:1
%    current_model = svmtrain(trainingData(i).x,trainingData(i).y);
        current_model = svmtrain(trainingData.y,trainingData.x);
%end

[predicted_label, acc, ~] = svmpredict(testData.y, testData.x, current_model);
confusionMatrix = confusionmat(testData.y, predicted_label);
SVMaccuracy = acc(1);    
risk = 100-SVMaccuracy;

end

