function [dataTrain, dataHoldout] = splitData(data, r)
%input: 
%   data - 1 x 1 struct with fields 'x' d x n matrix,  and 'y' a 1 x n
%   vector
%   r - the ratio of data to retain as training data (1 - r) is the ratio
%   of the hold out set

%output:
%   dataTrain - 1 x 1 struct with fields 'x' d x n' matrix (where n' is
%   floor(r*n)), and 'y' is a 1 x (r*n) vector
%   dataTest -  1 x1 struct with field 
    M = length(data.y);
    ind = floor(r * M);
    
    dataTrain.y = data.y(1 : ind);
    dataTrain.x = data.x(:, 1 : ind);
    
    dataHoldout.y = data.y(ind + 1 : end);
    dataHoldout.x = data.x(:, ind + 1 : end);
    
end
    
    
    
