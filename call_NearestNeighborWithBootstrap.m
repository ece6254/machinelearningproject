function [risk, confusionMatrix] = call_NearestNeighborWithBootstrap(trainingData, testData,numStraps)
x=trainingData.x; 

kVals = [1,5,9,15,21,25];
riskMat = zeros(length(kVals),numStraps);
for k=1:numStraps
    [valTrain.x, ind]=datasample(x,length(x));
    valTrain.y = trainingData.y(ind); 
    valInd = setxor(1:length(x),ind);
    valTest.x = x(valInd,:);
    valTest.y = trainingData.y(valInd);
    for i = 1:length(kVals)
            [riskMat(i,k), ~] = call_NearestNeighbor(valTrain,valTest,kVals(i));
    end
end

riskAvg = mean(riskMat,2);

[~,ind] = min(riskAvg);
kVals(ind)
[risk,confusionMatrix] = call_NearestNeighbor(trainingData,testData,kVals(ind));

end

