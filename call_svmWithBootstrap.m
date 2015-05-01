function [risk, confusionMatrix] = call_svmWithBootstrap(trainingData,testData,numStraps)

x=trainingData.x; 

Cvals = [0.001,0.01,0.05,0.1,1,2];
riskMat = zeros(length(Cvals),numStraps);
for k=1:numStraps
    [valTrain.x, ind]=datasample(x,length(x));
    valTrain.y = trainingData.y(ind); 
    valInd = setxor(1:length(x),ind);
    valTest.x = x(valInd,:);
    valTest.y = trainingData.y(valInd);
    for i = 1:length(Cvals)
        try
            [riskMat(i,k), ~] = call_svm(valTrain,valTest,1,Cvals(i));
        catch
            riskMat(i,k) = 1;
        end
    end
end

riskAvg = mean(riskMat,2);

[~,ind] = min(riskAvg);
Cvals(ind)
caughtErr = 1;
while caughtErr
    try
        [risk,confusionMatrix] = call_svm(trainingData,testData,1,Cvals(ind));
        caughtErr = 0;
    catch
        Cvals(ind) = [];
        riskAvg(ind) = [];
        [~,ind] = min(riskAvg);
        fprintf('try again:')
        Cvals(ind)
    end
    
end


end

