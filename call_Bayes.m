function [risk,confusionMatrix] = call_Bayes(trainingData,testData)
    nb = NaiveBayes.fit(trainingData.x,trainingData.y);
    yhat = predict(nb,testData.y);
    risk = mean(abs(testData.y-yhat));
    confusionMatrix = confusionmat(testData.y,yhat);
end

