function [ C ] = getSVMC( dataset, F )
%GETSVMC
%   Author: Sergio García-Vergara
%
%   [ C ] = getC( dataset, F )
%
%   Computes the regularization parameter for an SVM classifier based on
%   the training data provided. It performs cross-validation to average the
%   classification error and select the value that minimizes the error.
%
%   dataset: structure with:
%       x: data points
%       y: class IDs
%   Ffolds: number of folds for cross-validation (default 5)


% number of folds
Ffolds = 5;
if (nargin == 2)
    Ffolds = F;
end

% SELECT range of values for the C parameter
C_range = 1:1:100;

% create Ffolds
all_folds = createCVFolds(dataset, Ffolds);

% placeholder
C_acc = zeros(length(C_range), 1);

% loop counter
count = 0;

% go through all values of C
for c = C_range
    
    % display current C value
    disp(c);
    
    % update loop counter
    count = count + 1;
    
    % placeholder
    fold_acc = zeros(Ffolds, 1);
    
    % go through all folds
    for f = 1:Ffolds
        
        % define test and train sets
        clear test_set train_set
        [test_set, train_set] = getCVTestTrainingSets(all_folds, f);
        
        % train with current C value
        Cstring = ['-c', ' ', num2str(c), ' ', '-q'];

        % apply SVM to current dataset
        clear current_model
        current_model = svmtrain(train_set.y, train_set.x, Cstring);
        
        % compute classification accuracy with test set
        [~, acc, ~] = svmpredict(test_set.y, test_set.x, current_model);

        % store accuracies
        fold_acc(f) = acc(1);
    end
    
    % average classification accuracy for current C value
    C_acc(count) = mean(fold_acc);
    
end

% index of maximum classification accuracy
[~, ind] = max(C_acc);

% select C value that yields least classification error (highest
% classification accuracy)
C = C_range(ind);





global fignum;
f = 16;

fig = figure(fignum);   fignum = fignum + 1;
set(fig, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
plot(C_range, C_acc, 'linewidth', 2);
grid on
hold on
plot(C_range(ind), C_acc(ind), 'ro');
title('Accuracy vs C values', 'fontweight', 'bold', 'fontsize', f);
xlabel('C values', 'fontweight', 'bold', 'fontsize', f/1.2);
ylabel('Classification Accuracy [%]', ...
    'fontweight', 'bold', 'fontsize', f/1.2);
hold off


end