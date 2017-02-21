function x = multiply_by_transfer_matrix(obj, a, T, x)
  chi = size(T, 2);
  x = reshape(x, chi, obj.q, chi);
  % best sequence: 2 1 3 4 5
  x = ncon({T, a, T, x}, {[1 -1 2], [1 3 4 -2], [4 5 -3], [2 3 5]}, [2 1 3 4 5]);
  x = x(:);
end
