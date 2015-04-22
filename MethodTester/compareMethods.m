function [] = compareMethods(numDataSetsConsidered)
%COMPAREMETHODS given a datase, the function compares machine learning
%methods
%   

numStraps = 1;

load('AllTrainSets.mat');
load('AllTestSets.mat');

classificationMethods.names = {'Bay','SVM','NNC'};
classificationMethods.vector = [1,2,3];
featureSelectionMethods.names = {'NA','PCA','Go'};
featureSelectionMethods.vector = [0,1,2];
dataCreationMethods.names = {'NA','BS','VS'};
dataCreationMethods.vector = [0,2];
methodCombinations = combvec(featureSelectionMethods.vector,dataCreationMethods.vector,classificationMethods.vector);

confusionMatrices = zeros(2,2,size(methodCombinations,2),numDataSetsConsidered);
riskValues = zeros(size(methodCombinations,2),numDataSetsConsidered);
iVec = [];
for i = 1:numDataSetsConsidered
    %classifier = performMethods(dataSet(dataChosen,:),classificationVector(dataChosen))
    %bootstrapping - training set, will run iteration on training set.
    %Resampling techniques
    %creating virtual samples
    % tik reg
    %boosting - iterative.  take data classify once.  weight incorrectly
    %classified ones more.
    %pca.
    i
    
    try
        
    for j=1:size(methodCombinations,2)
        [riskValues(j,i), confusionMatrices(1:2,1:2,j,i)] = classifyData(AllTrainSets(i),AllTestSets,methodCombinations(1,j),methodCombinations(2,j),methodCombinations(3,j), numStraps);
        
    end
     
    catch 
        iVec = [iVec, i];
        fprintf('Caught an error at %i',i);
    end
    
    
end

confusionMatrices(:,:,:,iVec) = [];
riskValues(:,iVec) = [];

confusionMean = mean(confusionMatrices,4);
confusionMax = max(confusionMatrices,[],4);
confusionMin = min(confusionMatrices,[],4);
confusionSTD = std(confusionMatrices,0,4);

riskMean = mean(riskValues,2);
riskMax = max(riskValues,[],2);
riskMin = min(riskValues,[],2);
riskSTD = std(riskValues,0,2);


cellArrayOfNames = cell(1,size(methodCombinations,2));

for i = 1:size(methodCombinations,2)
    cellArrayOfNames{i} = [classificationMethods.names{methodCombinations(3,i)}, '/', featureSelectionMethods.names{methodCombinations(1,i)+1}, '/', dataCreationMethods.names{methodCombinations(2,i)+1}];
end

boxplot(riskValues', 'labels',cellArrayOfNames)
grid on
%meanHandle = barGraphData(riskMean, cellArrayOfNames, 'Risk Means');


end

