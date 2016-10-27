% Takes sign into account
% axes should be 'x', 'y' or 'both'
function logplot(x, y_matrix, axes)
  x = sign(x) * log(abs(x));
end
