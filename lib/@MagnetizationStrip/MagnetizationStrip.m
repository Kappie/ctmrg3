classdef MagnetizationStrip < Quantity
  methods(Static)
    function value = value_at(temperature, C, T)
      a = Util.construct_a(temperature);
      b = Util.construct_b(temperature);

      % % Construct T - a - T
      % transfer_matrix = ncon({T, a, T}, {[1 -1 -4], [1 -2 2 -5], [2 -3 -6]});
      %
      % % reshape into 2chi^2 x 2chi^2 matrix
      % [transfer_matrix, ~, ~] = lreshape(transfer_matrix, [1 2 3], [4 5 6]);

      number_of_eigenvalues = 1;
      [eigenvectors, eigenvalues] = Util.largest_eigenvalues_transfer_matrix(a, T, number_of_eigenvalues);
      % [~, eigenvalues_T_ball] = Util.largest_eigenvalues_transfer_matrix(b, T, number_of_eigenvalues);

      dominant_eigenvector = eigenvectors(:, 1);

      % middle column represents T - b - T, where represents summation over spin config
      % times spin eigenvalue on a site.
      middle_column = ncon({T, b, T}, {[1 -1 -4], [1 -2 2 -5], [2 -3 -6]});
      % reshape into 2chi^2 x 2chi^2 matrix
      [middle_column, ~, ~] = lreshape(middle_column, [1 2 3], [4 5 6]);

      % Now, this represents the unnormalized expectation value of a spin in the center of the lattice
      value = dominant_eigenvector' * middle_column * dominant_eigenvector;
      % This already has norm 1. (why?)
      % norm = dominant_eigenvector' * dominant_eigenvector
      % norm is equal to largest eigenvalue transfer matrix (why? What happened to power of l?)
      norm = eigenvalues(1);
      % if ~IsNear(norm, eigenvalues(1), 1e-14)
      %   diff = norm - eigenvalues(1)
      %   disp(['not near for chi = ' num2str(size(C, 1))])
      % end
      value = value / norm;
    end
  end
end
