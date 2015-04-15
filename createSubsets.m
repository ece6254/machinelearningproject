
% ========================================================================
%
% Author: Sergio García-Vergara
% Date Created: April 11, 2015
%
% This mfile takes as input a dataset with its rows as instances and
% columns as features. It creates n subsets with different numbers of
% instances (defined in the variables) by randomly selecting instances from
% the original dataset.
%
% ========================================================================

clear all
close all
clc
tic

%%
% EXTRACT 340 INSTANCES TO CREATE THE TEST SET
% HALF FROM EACH CLASS

%%
% CREATE AN 'OFFICIAL' TRAIN AND TEST SUBSETS SO THAT THE GROUP CAN TEST
% THEIR OWN CODE

%%
% USE THE SVM (AND NAIVE BAYES?) CLASSIFIER TO DETERMINE WHAT IS SMALL

%%
% EXTRACT BY 50s ALL THE WAY TO 700


%% Variables
% ------------

% SELECT number of instances in each new subset
numInstSub = 50:50:700;

% SELECT class distribution for all subsets
c1 = 0.5;
c2 = 1 - c1;

% number of instances for test set
numInstTest = 340;

% directory containing data
addpath('./ParkinsonData');

% original dataset
instances = load('train_data.txt');

% number of instances and features
numInstances = size(instances, 1);
numFeatures  = 26;  % constant taken from dataset description 

% verify that the number of instances in teh subsets is less than the
% number of instances in the original dataset
if (sum(numInstSub >= numInstances) > 0)
    error('Rethink number of instances for subsets.');
end



%% Organize Dataset
% Extract relevant information and create structures
% ---------------------------------------------------

disp('Organizing Dataset...');

% participant IDs
dataPoints.ID = instances(:,1);

% actual data points
dataPoints.x = instances(:, 2:27);

% class ids
dataPoints.y = instances(:,end);

% separation of classes
ind = find(dataPoints.y == 0);
dataPoints.class1.ID = dataPoints.ID(ind);
dataPoints.class1.x = dataPoints.x(ind, :);
dataPoints.class1.y = dataPoints.y(ind);

ind = find(dataPoints.y == 1);
dataPoints.class2.ID = dataPoints.ID(ind);
dataPoints.class2.x = dataPoints.x(ind, :);
dataPoints.class2.y = dataPoints.y(ind);


disp('Organizing Dataset... Complete');
disp(' ');


%% Create Test Set
% Common test set with 50/50 class distribution
% ----------------------------------------------

disp('Creating test set...');

% placeholders
test_set.x = zeros(numInstTest, numFeatures);
test_set.y = zeros(numInstTest);

% ind to extract from class1
ind_class1 = datasample(1:length(dataPoints.class1.y), numInstTest/2, ...
    'replace', false);
ind_class1 = sort(ind_class1)';

% ind to extract from class2
ind_class2 = datasample(1:length(dataPoints.class2.y), numInstTest/2, ...
    'replace', false);
ind_class2 = sort(ind_class2)';

% create test set
test_set.x = dataPoints.class1.x(ind_class1, :);
test_set.x = [test_set.x; dataPoints.class2.x(ind_class2, :)];

test_set.y = dataPoints.class1.y(ind_class1);
test_set.y = [test_set.y; dataPoints.class2.y(ind_class2)];

% export test set to .mat file
save('common_test_set.mat', '-struct', 'test_set');

% eliminate extracted instances from original dataset
clear ind
ind = (1:length(dataPoints.class1.y))';
ind(ind_class1) = [];
train_set.class1.ID = dataPoints.class1.ID(ind);
train_set.class1.x = dataPoints.class1.x(ind, :);
train_set.class1.y = dataPoints.class1.y(ind);

clear ind
ind = (1:length(dataPoints.class2.y))';
ind(ind_class2) = [];
train_set.class2.ID = dataPoints.class2.ID(ind);
train_set.class2.x = dataPoints.class2.x(ind, :);
train_set.class2.y = dataPoints.class2.y(ind);


disp('Creating test set... Complete');
disp(' ');


%% Create Subsets
% ---------------

disp('Creating Subsets...');

% number of subets to create
numSubs = length(numInstSub);

% go through all subsets
for i = 1:numSubs
    
    % temporary variables
    clear ind1 ind2 randPoints filename
    
    % random indices
    ind1 = datasample(1:length(train_set.class1.y), c1*numInstSub(i), ...
        'replace', false);
    ind1 = sort(ind1)';
    
    ind2 = datasample(1:length(train_set.class2.y), c2*numInstSub(i), ...
        'replace', false);
    ind2 = sort(ind2)';
    
    % extract the random points from original dataset
    randPoints.ID = train_set.class1.ID(ind1);
    randPoints.x  = train_set.class1.x(ind1, :);
    randPoints.y  = train_set.class1.y(ind1);
    
    randPoints.ID = [randPoints.ID; train_set.class2.ID(ind2)];
    randPoints.x  = [randPoints.x;  train_set.class2.x(ind2, :)];
    randPoints.y  = [randPoints.y;  train_set.class2.y(ind2)];
    
    % current filename
    filename = strcat('subset', num2str(numInstSub(i)), '.mat');
    
    % delete if file already exists (ask first)
    if (exist(filename, 'file') ~= 0)
        msg = sprintf('Can I delete %s? [0/1]   ', filename);
        c = input(msg);
        if (c == 0)
            error('File not deleted. Code Stopped.');
        end
    end
    
    % store new subset in corresponding .mat file
    save(filename, '-struct', 'randPoints');
end


disp('Creating Subsets... Complete');
disp(' ');



%% End

toc

