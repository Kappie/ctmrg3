function value = free_energy(obj, C, T)
  Z = obj.partition_function(C, T);
  four_corners = trace(C^4);
  one_row = ncon({C, T, C}, {[-1 1], [-2 1 2], [2 -3]});
  % reshape into vector
  one_row = lreshape(one_row, [1 2 3], []);
  two_rows = one_row' * one_row;
  kappa = Z * four_corners / two_rows^2;
  value = -obj.temperature*log(kappa);
end
