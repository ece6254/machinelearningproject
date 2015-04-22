function [risk, confusionMatrix] = classifyData(trainingData,testData,featureSelectionMethod,dataCreationMethod,classificationMethod, numStraps)


%notes: should we normalize the confusion matrix to make it percentages?




k = 1; %we average classifiers over k for bootstrapping.  Right now it's just 1.

switch featureSelectionMethod
        
    case 1  %PCA?
        
        %call function here
        %[trainingData, testData] = function(trainingData, testData);
        [trainingData,testData] = reducePCA(trainingData,testData,20);
    case 2  %other method

        %call function here
        %[trainingData, testData] = function(trainingData, testData);
        [trainingData,testData] = reduceGoDec(trainingData,testData,20);
        
end

switch dataCreationMethod
            
    case 1  %bootstrap?
        %[trainingData, k] = call_Bootstrap(trainingData, numStraps);
        %call function here.
        %[trainingData, k] = function(trainingData);
        %maybe datCreatTrainData should be a cell array to separate data sets?
    case 2  %other method
        trainingData = call_VirtualData(trainingData, 0.5);       
        %call function here
        %trainingData = function(trainingData);
        
end


switch classificationMethod
        
    case 1  %bayes?
        %call function here.
        %[classifier, rHat] = train(trainingData,k);
        %risk = classify(testData)
        [risk, confusionMatrix] = call_Bayes(trainingData,testData);
        
        
    case 2  %SVM?
        %call function here
        %[classifier, rHat] = train(trainingData,k);
        %risk = classify(testData)
        [risk, confusionMatrix] = call_svm(trainingData, testData, numStraps);
        
    case 3
        
        [risk, confusionMatrix] = call_NearestNeighbor(trainingData,testData,5);
    otherwise
        %throw error
        msgID = '';
        msg = 'You must actually select a classifier.';
        exception = MException(msgID,msg);
        throw(exception);
        
end


end

