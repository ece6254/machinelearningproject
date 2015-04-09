clc;
clear;

tempData = load('mnist_49_3000');

%data is a struct with fields 'x' and 'y'. 
data = permuteData(tempData);
r = 0.7; % r is the ratio retained of data retained as training data

%dataTrain is a struct with fields 'x' and 'y' the size of the data is
%r*size of original data
%dataTest is a struct with fields 'x' and 'y' the size of the data is
%(1-r)*size of original data
[dataTrain, dataTest] = splitData(data, r);

%thetaSVM is a SVM
thetaSVM = fitcsvm(dataTrain.x', dataTrain.y);
riskSVM = empiricalRisk(thetaSVM, dataTest);
display(riskSVM)

%thetaNB = fitcnb(dataTrain.x', dataTrain.y);



