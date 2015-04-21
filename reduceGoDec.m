function [dataTrain, dataTest] = reduceGoDec(dataTrain, dataTest, k)
% input :  dataTrain.x is an n x d array. n = number of observations and d 
%          is the dimension of each observation
%          dataTest.x is an n' x d array. n' = number of observations and d
%          is the dimension of each observation
%          k (0 < k <= d) is the rank of the array you want to return.

% output : dataTrain is a struct with fields 'x' an n x k and 'y' an 
%          n x 1 vector
%          dataTest is a struct with fields 'x' and n' x k and 'y' and n x
%          1 vector

    %The following code segment obtains the mean of the training data and
    %subtracts it from the data such that the training data is zero mean
    mu = mean(dataTrain.x, 1); % mu ~ 1 x d
    MU = repmat(mu, size(dataTrain.x, 1), 1); % MU ~ N x d
    X = dataTrain.x - MU; % X ~ N x d
    clear MU

    %The following code segment initializes the parameters for the GoDec
    %algorithm and then calls it. L is the low rank (rank k) estimate that
    %best explains the training data x
    numNonZeros = nnz(dataTrain.x(:));
    card = floor(0.01 * numNonZeros);  %number of sparse components 
    exponent = 5; % a paramter described in the author's a paper
    [L, ~, ~, ~] = GoDec(X, k, card, exponent);
    
    %The next code segment obtains the singular value decomposition for the
    %low rank matrix L. Recall that X = mu + A * Theta. Where Theta is the
    %first k columns of U and A is the first k columns of (S * V')'
    [U, S, V] = svd(L);
    Theta = U(:, 1 : k);
    dataTrain.x = Theta;
    ATemp = (S*V')';
    A = ATemp(:, 1 : k);
    
    %Subtract off the mean from new data such that the new data is also
    %zero mean.
    MU = repmat(mu, size(dataTest.x, 1), 1);
    X = dataTest.x - MU;
    %dataTest.x is the n' x k array of the lower dimensional data.
    dataTest.x = (A\X')';
    

end