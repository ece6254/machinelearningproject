function [ output_args ] = compareMethods(dataSet,classificationVector,smallDataSize,largeDataSize)
%COMPAREMETHODS given a datase, the function compares machine learning
%methods
%   

[n,d] = size(dataSet);

for i = 1:100
    dataChosen = randperm(n,smallDataSize);
    %classifier = performMethods(dataSet(dataChosen,:),classificationVector(dataChosen))
    %bootstrapping - training set, will run iteration on training set.
    %Resampling techniques
    %creating virtual samples
    % tik reg
    %boosting - iterative.  take data classify once.  weight incorrectly
    %classified ones more.
    %pca.
    
    
end





end

