function [Xout, numStraps]= call_Bootstrap(TrainDataString, numStraps)

% numStraps determines the # of subsets of data output
% Size will be 

train_set = load(TrainDataString);
x=train_set.x; 

for k=1:numStraps
    [y, ind]=datasample(x,length(x));
    y_labels=train_set.y(ind); 
    Y(numStraps+1-k)=struct('x',y,'y',y_labels); 
end

Xout=Y; 
end
