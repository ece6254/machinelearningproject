function Y= call_VirtualData(train_set, NoiseParameter)

%This function takes a training set and optional noise Paramter as input
%and add random gaussian noise based on the variance of the training data.
%The NoiseParameter, if not set, is tuned to be 0.5 based off of Lee's
%2000 paper. The output is a structure of the same type and size as the
%input. 

if  length(nargin)<2
    NoiseParameter=0.5; 
end

% determine variance of each feature across all instannces, turn into
% matrix of same size as data to get all noise independently by each
% instance.

sigmaMat=repmat(var(train_set.x),length(train_set.y),1); 
N=normrnd(0,sigmaMat); % gets matrix of noise
xNew=train_set.x+NoiseParameter*N; % adds noise, with parameter NoiseParameter
Y=struct('x',xNew,'y',train_set.y); 
end
