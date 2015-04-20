function [ all_folds ] = createCVFolds( dataset, fold_size )
%CREATECVFOLDS
%   Author: Sergio García-Vergara
%
%   [ all_folds ] = createCVFolds( dataset, fold_size )
%
%   Given a set of data points, this script separates it into 'fold_size'
%   amount of subsets, each containing the same amount of instances. These
%   subsets/folds are later use in the cross-validation process.
%
%   NOTE: The 'dataset' input must be a structure containing teh following
%   fields:
%   x: dataset's instances
%   y: class IDs
%
%   The 'all_folds' output will also be a structure containing the same
%   fields.


% total number of rows in the dataset
rows = size(dataset.x, 1);

% get number of instances in each fold
rows_per_fold = floor(rows / fold_size);

% placeholder
% all_folds(fold_size).x = zeros(rows_per_fold, cols);
% all_folds(fold_size).y = zeros(rows_per_fold, 1);

all_folds(fold_size) = struct('x', 0, 'y', 0);

% temporary variable
clone_set.x = dataset.x;
clone_set.y = dataset.y;

% create folds
for f = 1:fold_size
    
    % current size of the temporary variable (rows remaining)
    current_size = size(clone_set.x, 1);
    
    % pick ind
    clear ind
    ind = datasample(1:current_size, rows_per_fold, 'replace', false);
    ind = sort(ind);

    % extract the randomly selected indeces
    all_folds(f).x = clone_set.x(ind,:);
    all_folds(f).y = clone_set.y(ind);

    % eliminate instances that were already extracted
    clone_set.x(ind,:) = [];
    clone_set.y(ind)   = [];
    
end


end

