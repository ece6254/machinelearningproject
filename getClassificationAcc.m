function [ acc ] = getClassificationAcc( classIDs, predictions )
%GETCLASSIFICATIONACC
%   Author: Sergio García-Vergara
%
%   [ acc ] = getClassificationAcc( classIDs, predictions )
%
%   Given a vector of class labels and a vector of teh predicted labels,
%   this mfile computes and returns the classification accuracy as the
%   number of correct predictions made over the total amount of elements in
%   the vectors. (Vectors must be of same length).


% verify that both input vectors have the same length
if (length(classIDs) ~= length(predictions))
    error('Vectors must have the smae length.');
end

% number of elements in the vectors
n = length(classIDs);

% values that are correctly classified
ind = (classIDs == predictions);

% compute the final classification accuracy
acc = sum(ind) / n;
acc = 100 * acc;


end
