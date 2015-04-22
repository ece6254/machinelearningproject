function [dataTrain, dataTest] = reducePCA(dataTrain, dataTest, k)
% input : data.x an n x d array. n = number of observations and d is the
% dimension of each observation
%         k (0 < k <= d) number of principal components.
%
% output : A (Theta_new = A \ (data.x_new - mu))

    %The following code segment obtains the mean of the training data and
    %subtracts it from the data such that the training data is zero mean
    mu = mean(dataTrain.x, 1); % mu ~ 1 x d
    MU = repmat(mu, size(dataTrain.x, 1), 1); % MU ~ N x d
    X = dataTrain.x - MU; % X ~ N x d
    clear MU
    
    
    % ATemp is approximately the A matrix discussed in class. However, it
    % is a d x d matrix as opposed to being a d x k matrix. Therefore, we
    % select the first k columns of Atemp to form A and the first k columns
    % of ThetaTemp to form Theta. Theta is rows of Theta are the
    % transformed observations
    [ATemp, ThetaTemp] = pca(X);
    A = ATemp(:, 1 : k);
    %size(A)
    dataTrain.x = ThetaTemp(:, 1 : k);
    
    %Subtract off the mean from new data such that the new data is also
    %zero mean.
    MU = repmat(mu, size(dataTest.x, 1), 1);
    X = dataTest.x - MU;
    
    %dataTest.x is the N x k array of the lower dimensional data.
    dataTest.x = (A\X')';

end
    