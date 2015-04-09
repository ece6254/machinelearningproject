function newData = permuteData(data)
%Function: permute the data while making sure that the permuted data has a
%fixed seed. 
% Input: 
%   data - 1 x 1 struct with fields 'x' a d x n matrix,  and 'y' a 1 x n
%   vector
%Output:
%   newData - 1 x 1 struct with fields 'x'  a d x n matrix, and 'y' a 1 x n
%   vector


    s = RandStream('mt19937ar', 'Seed',0);
    M = length(data.y);
    ind = randperm(s, M);
    
    newData.y = data.y(ind);
    newData.x = data.x(:, ind);
    
end