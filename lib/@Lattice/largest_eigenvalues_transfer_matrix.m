function [eigenvectors, eigenvalues] = largest_eigenvalues_transfer_matrix(obj, T, number_of_eigenvalues)
  % Diagonalize using a custom function to multiply T*x
  a = obj.construct_a();
  chi = size(T, 2);
  transfer_matrix_size = obj.q * chi * chi;

  function x = multiply_by_transfer_matrix(x)
    x = obj.multiply_by_transfer_matrix(a, T, x);
  end

  [eigenvectors, diagonal] = eigs(@multiply_by_transfer_matrix, ...
    transfer_matrix_size, number_of_eigenvalues);
  eigenvalues = diag(diagonal);
  % Let's not sort this here; the order of eigenvectors gets messed up.
  % eigenvalues = sort(diag(diagonal), 'descend');

  if number_of_eigenvalues > 1
    if IsNear(eigenvalues(1), eigenvalues(2), 1e-10)
      warning(['degenerate largest eigenvalue of transfer matrix for T = ' num2str(temperature)])
    end
  end
end
