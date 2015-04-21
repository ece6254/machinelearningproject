
% ========================================================================
%
% Author: Sergio García-Vergara
% Date Created: April 21, 2015
%
% This mfile takes as input a dataset with its rows as instances and
% columns as features. A test set is extracted from the original dataset,
% and then the mfile creates n subsets (all with the same number of
% instances) from the reamaining points.
%
% NOTE: Given that the complete dataset is composed of multiple instances
% from the same individual, the mfile makes sure that the train sets do not
% contain instances from the same individual as in the test set.
%
% ========================================================================

clear all
close all
clc
tic


%% Variables
% ------------

% SELECT number of instances in each new subset (constant)
numInstSub = 100;

% SELECT number of subsets to be created
numSubsets = 100;

% SELECT class distribution for all subsets
c1 = 0.5;
c2 = 1 - c1;

% SELECT number of participants to extract from each class
numParticipants = 7;

% instances per participant
int_per_person = 26;

% directory containing data
addpath('./ParkinsonData');

% original dataset
instances = load('train_data.txt');

% number of instances and features
numInstances = size(instances, 1);
numFeatures  = 26;  % constant taken from dataset description 

% verify that the number of instances in the subsets is less than the
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

% instances for test set per class
instPerClass = numParticipants * int_per_person;

% extract all instances from the first numParticipants of each class
AllTestSets.ID = dataPoints.class1.ID(1:instPerClass);
AllTestSets.ID = [AllTestSets.ID; dataPoints.class2.ID(1:instPerClass)];
    
AllTestSets.x = dataPoints.class2.x(1:instPerClass, :);
AllTestSets.x = [AllTestSets.x; dataPoints.class2.x(1:instPerClass, :)];

AllTestSets.y = dataPoints.class1.y(1:instPerClass);
AllTestSets.y = [AllTestSets.y; dataPoints.class2.y(1:instPerClass)];

% export test set to .mat file
save('AllTestSets.mat', 'AllTestSets');


% eliminate extracted instances from original dataset
clear ind
ind = (1:length(dataPoints.class1.y))';
ind(1:instPerClass) = [];
train_set.class1.ID = dataPoints.class1.ID(ind);
train_set.class1.x  = dataPoints.class1.x(ind, :);
train_set.class1.y  = dataPoints.class1.y(ind);

clear ind
ind = (1:length(dataPoints.class2.y))';
ind(1:instPerClass) = [];
train_set.class2.ID = dataPoints.class2.ID(ind);
train_set.class2.x  = dataPoints.class2.x(ind, :);
train_set.class2.y  = dataPoints.class2.y(ind);


disp('Creating test set... Complete');
disp(' ');


%% Create Subsets
% ---------------

disp('Creating Subsets...');

% placeholder
AllTrainSets(numSubsets) = struct('ID', 0, 'x', 0, 'y', 0);

% go through all subsets
for i = 1:numSubsets
    
    % temporary variables
    clear ind1 ind2 randPoints filename
    
    % random indices
    ind1 = datasample(1:length(train_set.class1.y), c1*numInstSub, ...
        'replace', false);
    ind1 = sort(ind1)';
    
    ind2 = datasample(1:length(train_set.class2.y), c2*numInstSub, ...
        'replace', false);
    ind2 = sort(ind2)';
    
    % extract the random points from original dataset
    randPoints.ID = train_set.class1.ID(ind1);
    randPoints.x  = train_set.class1.x(ind1, :);
    randPoints.y  = train_set.class1.y(ind1);
    
    randPoints.ID = [randPoints.ID; train_set.class2.ID(ind2)];
    randPoints.x  = [randPoints.x;  train_set.class2.x(ind2, :)];
    randPoints.y  = [randPoints.y;  train_set.class2.y(ind2)];
    
    % add current set to the train set structure
    AllTrainSets(i).ID = randPoints.ID;
    AllTrainSets(i).x  = randPoints.x;
    AllTrainSets(i).y  = randPoints.y;
    
end

% save the final structure to a .mat file
save('AllTrainSets.mat', 'AllTrainSets');


disp('Creating Subsets... Complete');
disp(' ');



%% End

toc

