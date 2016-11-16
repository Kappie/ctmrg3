classdef CorrelationLengthAfun < Quantity
  methods(Static)
    function value = value_at(temperature, ~, T)
      % Diagonalize using a custom function to multiply T*x
      chi = size(T, 2);
      transfer_matrix_size = 2 * chi * chi;
      a = Util.construct_a(temperature);

      function x = multiply_by_transfer_matrix(x)
        x = Util.multiply_by_transfer_matrix(a, T, x);
      end

      eigenvalues = eigs(@multiply_by_transfer_matrix, transfer_matrix_size, 2);
      eigenvalues = sort(eigenvalues, 'descend');

      if IsNear(eigenvalues(1), eigenvalues(2), 1e-10)
        warning(['degenerate largest eigenvalue of transfer matrix for T = ' num2str(temperature)])
      end

      value = 1 / log(eigenvalues(1) / eigenvalues(2));
    end
  end
end
