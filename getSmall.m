
% ========================================================================
%
% Author: Sergio García-Vergara
% Date Created: April 11, 2015
%
% This mfile takes as input a series of datasets with different amounts of
% instances (previously generated). It applies an SVM and a Naive Bayes
% classifier to each dataset, and it computes the classification accuracy
% for each with a common test set (previoulsy generated). At the end, the
% mfile plots the classification accuracy vs the number of instances in
% order to determine "what is a small number of instances?" for each
% classifier or interest.
%
% ========================================================================

clear all
close all
clc
tic

%% Variables
% ----------

% SELECT scaled or not
scaled = 1;     % [0/1]

% SELECT folder which defines the subsets to be used
folder = './by10s/';

% SELECT number of instances in each new subset
numInstSub = 50:10:700;

% SELECT if we want to compute the best regularization parameter or not
getbestC = 0;   % [0/1]

% add all necessary paths
addpath('./ParkinsonData');
addpath('./libsvm/matlab');

% number of current figure
global fignum;
fignum = 1;


%% Import Common Test Set
% -----------------------

disp('Importing Test Set...');

% filename
filename = strcat(folder, 'common_test_set.mat');

% load
test_set = load(filename);

% scale the data (if variable is yes)
if (scaled == 1)
    test_set.x = zscore(test_set.x);
end


disp('Importing Test Set... Complete');
disp(' ');


%% Import Subsets
% --------------

disp('Importing all datasets...');

% placeholder
datasets(length(numInstSub)) = struct('ID', 0, 'x', 0, 'y', 0);

% loop counter
count = 0;

% go over all sets
for i = numInstSub
    
    % update loop counter
    count = count + 1;
    
    % get current filename
    clear filename
    filename = strcat(folder, 'subset', num2str(i), '.mat');
    
    % load current file
    datasets(count) = load(filename); 
    
end

disp('Importing all datasets... Complete');
disp(' ');



%% Apply SVM
% -----------

disp('Applying SVM...');

% placeholders
SVMaccuracy = zeros(length(numInstSub), 1);
C_range = zeros(length(numInstSub), 1);
CM_svm(length(numInstSub)) = struct('table', 0);

% go through all datasets
for i = 1:length(numInstSub)
    
    % display current dataset
    disp(strcat('Current Dataset: ', num2str(numInstSub(i))));
    
    % current dataPoints
    clear dataPoints
    dataPoints.x = datasets(i).x;
    dataPoints.y = datasets(i).y;
    
    % scale the training and test data (if variable selected)
    if (scaled == 1)
        dataPoints.x = zscore(dataPoints.x);
    end
    
    % compute the regularization parameter C
    C = 1;
    if (getbestC == 1)
        C = getSVMC(dataPoints);
    end
    C_range(i) = C;
    Cstring = ['-c', ' ', num2str(C)];
    
    % apply SVM to current dataset
    clear current_model
    current_model = svmtrain(dataPoints.y, dataPoints.x, Cstring);
    
    % compute classification accuracy with test set
    [predicted_label, acc, ~] = ...
        svmpredict(test_set.y, test_set.x, current_model);
    
    % compute and store current confusion matrix
    CM_svm(i).table = confusionmat(test_set.y, predicted_label);
    
    % store accuracies
    SVMaccuracy(i) = acc(1);    
    
    % chill for a bit
    pause(0.5);
    disp(' ');
end


disp('Applying SVM... Complete');
disp(' ');


%% Apply Naive Bayes
% -------------------

disp('Applying Naive Bayes...');

% placeholders
NBaccuracy = zeros(length(numInstSub), 1);
CM_nb(length(numInstSub)) = struct('table', 0);

% go through all datasets
for i = 1:length(numInstSub)
    
    % display current dataset
    disp(strcat('Current Dataset: ', num2str(numInstSub(i))));
    
    % current dataPoints
    clear dataPoints
    dataPoints.x = datasets(i).x;
    dataPoints.y = datasets(i).y;
    
    % scale the training and test data (if variable selected)
    if (scaled == 1)
        dataPoints.x = zscore(dataPoints.x);
    end
    
    % use default Gaussian distribution
    clear current_model
    current_model = NaiveBayes.fit(dataPoints.x, dataPoints.y);
    
    % classification predictions
    clear prediction
    prediction = current_model.predict(test_set.x);
    
    % compute accuracy
    NBaccuracy(i) = getClassificationAcc(test_set.y, prediction);

    % chill for a bit
    pause(0.5);
    disp(' ');
    
end


disp('Applying Naive Bayes... Complete');
disp(' ');




%% Plot
% ------

disp('Plotting...');

% line width and font size
w = 2;
f = 16;

% SVM classification accuracy vs number of instances in dataset
tit = 'SVM: Classification Accuracy vs Number of Instances';
if (scaled == 1)
    tit = sprintf('%s (Scaled Data)', tit);
end

fig = figure(fignum);   fignum = fignum + 1;
set(fig, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);

plot(numInstSub, SVMaccuracy, 'linewidth', w);
grid on
title(tit, 'fontweight', 'bold', 'fontsize', f);
xlabel('Number of Instances per Dataset', ...
    'fontweight', 'bold', 'fontsize', f/1.2);
ylabel('Classification Accuracy [%]', ...
    'fontweight', 'bold', 'fontsize', f/1.2);


% Naive Bayes classification accuracy vs number of instances in datasets
tit = 'Naive Bayes: Classification Accuracy vs Number of Instances';
if (scaled == 1)
    tit = sprintf('%s (Scaled Data)', tit);
end

fig = figure(fignum);   fignum = fignum + 1;
set(fig, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);

plot(numInstSub, NBaccuracy, 'linewidth', w);
grid on
title(tit, 'fontweight', 'bold', 'fontsize', f);
xlabel('Number of Instances per Dataset', ...
    'fontweight', 'bold', 'fontsize', f/1.2);
ylabel('Classification Accuracy [%]', ...
    'fontweight', 'bold', 'fontsize', f/1.2);




disp('Plotting... Complete');
disp(' ');



%% End
% ------

toc
