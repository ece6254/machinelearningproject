function [Y, numStraps]= call_Bootstrap(train_set, numStraps)

% numStraps determines the # of subsets of data output
% Size will be 

x=train_set.x; 


for k=1:numStraps
    [y, ind]=datasample(x,length(x));
    y_labels=train_set.y(ind); 
    Y(numStraps+1-k)=struct('x',y,'y',y_labels); 
end

end
