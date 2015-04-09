function R = empiricalRisk(model, data)
%Input: 
%   model - classifier object
%   data - 1 x 1 struct with fields 'x' a d x n matrix,  and 'y' a 1 x n
%   vector
%output:
%   R - empirical risk
    M = length(data.y);
    errors = 0;
    
    for m = 1 : M,
        
        if (predict(model, data.x(:, m)') ~= data.y(:, m))
            errors = errors + 1;
        end
        
    end
    
    R = errors/M;
    
end
        