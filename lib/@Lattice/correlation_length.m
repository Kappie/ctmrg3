function value = correlation_length(obj, C, T)
  number_of_eigenvalues = 2;
  [~, eigenvalues] = obj.largest_eigenvalues_transfer_matrix(T, number_of_eigenvalues);
  eigenvalues = sort(eigenvalues, 'descend');
  value = 1 / log(eigenvalues(1) / eigenvalues(2));
end
