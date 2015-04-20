function [ test_set, train_set ] = getCVTestTrainingSets( all_folds, fold )
%GETCVTESTTRAININGSETS
%   Author: Sergio García-Vergara
%
%   [ testSet, trainSet ] = getCVTestTrainingSets( all_folds, fold )
%
%   Given some already separated folds, this script - with help from an
%   external for loop - takes care of choosing one of the folds as the test
%   set and the remaining folds as the training sets.
%
%   all_folds: structure containing each fold in the third dimension
%   fold: current fold in the external for loop


% total number of folds
fold_size = size(all_folds, 2);

% test set is one of the folds (selected by external for loop)
test_set.x = all_folds(fold).x;
test_set.y = all_folds(fold).y;

% training set is the remaining folds
remaining_folds         = all_folds;
remaining_folds(fold).x = [];
remaining_folds(fold).y = [];

% placeholder
train_set.x = [];
train_set.y = [];

for i = 1:(fold_size-1)
    train_set.x = [train_set.x; remaining_folds(i).x];
    train_set.y = [train_set.y; remaining_folds(i).y];
end

saveVar(remaining_folds, 'remaining_folds');

end

