classdef CorrelationLengthAfun2 < Quantity
  methods(Static)
    function value = value_at(temperature, ~, T)
      a = Util.construct_a(temperature);

      number_of_eigenvalues = 2;
      [~, eigenvalues] = largest_eigenvalues_transfer_matrix(T, ...
        number_of_eigenvalues);

      value = 1 / log(eigenvalues(1) / eigenvalues(2));
    end
  end
end

function [eigenvectors, eigenvalues] = largest_eigenvalues_transfer_matrix(...
    T, number_of_eigenvalues)
  % Diagonalize using a custom function to multiply T*x
  chi = size(T, 2);
  transfer_matrix_size = chi * chi;

  function x = multiply(x)
    x = multiply_by_transfer_matrix(T, x);
  end

  [eigenvectors, diagonal] = eigs(@multiply, ...
    transfer_matrix_size, number_of_eigenvalues);
  eigenvalues = sort(diag(diagonal), 'descend');

  if number_of_eigenvalues > 1
    if IsNear(eigenvalues(1), eigenvalues(2), 1e-10)
      warning(['degenerate largest eigenvalue of transfer matrix for T = ' num2str(temperature)])
    end
  end
end

function x = multiply_by_transfer_matrix(T, x)
  chi = size(T, 2);
  x = reshape(x, chi, chi);

  x = ncon({T, T, x}, {[1 -1 2], [1 -2 3], [2 3]}, [2 3 1]);

  x = x(:);
end
