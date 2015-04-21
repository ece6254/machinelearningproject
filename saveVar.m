function saveVar( variable, newname )
%SAVEVAR(VARIABLE, NEWNAME)
%   Author: Sergio Garc�a-Vergara
%
%   assignin('base', newname, variable);
%
%   Function that takes care of exporting a variable in a function to the
%   workspace.


assignin('base', newname, variable);

end

