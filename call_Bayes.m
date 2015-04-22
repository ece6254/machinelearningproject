function [risk, confusionMatrix] = call_Bayes(trainingData,testData)

    % scale data
    trainingData.x = zscore(trainingData.x);
    testData.x = zscore(testData.x);
    
    % train data
    nb = NaiveBayes.fit(trainingData.x, trainingData.y);
    
    % predict data
    yhat = nb.predict(testData.x); %corrected. 
    %yhat = predict(nb,testData.y);% thought this
    
    % compute risk
    risk = mean(abs(testData.y-yhat));
    
    % compute confusion matrix
    confusionMatrix = confusionmat(testData.y,yhat);
end

