classdef CorrelationLength < Quantity
  methods(Static)
    function value = value_at(temperature, ~, T)
      % Construct T - a - T
      transfer_matrix = ncon({T, Util.construct_a(temperature), T}, {[1 -1 -4], [1 -2 2 -5], [2 -3 -6]});

      % reshape into 2chi^2 x 2chi^2 matrix
      [transfer_matrix, ~, ~] = lreshape(transfer_matrix, [1 2 3], [4 5 6]);

      % Degeneracies? Seems to be fine.
      eigenvalues = sort(eigs(transfer_matrix, 2), 'descend');
      if IsNear(eigenvalues(1), eigenvalues(2), 1e-10)
        warning(['degenerate largest eigenvalue of transfer matrix for T = ' num2str(temperature)])
      end
      value = 1 / log(eigenvalues(1) / eigenvalues(2));
    end
  end
end
