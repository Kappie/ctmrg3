classdef Util
  methods(Static)
    function C = spin_up_initial_C(temperature)
      spin_up_tensor = Util.corner_delta();
      spin_up_tensor(2, 2) = 0;
      P = Util.construct_P(temperature);
      C = ncon({P, P, spin_up_tensor}, {[-1 1], [-2 2], [1 2]});
    end

    function T = spin_up_initial_T(temperature)
      spin_up_tensor = Util.edge_delta();
      spin_up_tensor(2, 2, 2) = 0;
      P = Util.construct_P(temperature);
      T = ncon({P, P, P, spin_up_tensor}, {[-1 1], [-2 2], [-3 3], [1 2 3]});
    end

    function C = symmetric_initial_C(temperature)
      delta = Util.corner_delta();
      P = Util.construct_P(temperature);
      C = ncon({P, P, delta}, {[-1, 1], [-2, 2], [1, 2]});
    end

    function T = symmetric_initial_T(temperature)
      delta = Util.edge_delta();
      P = Util.construct_P(temperature);
      T = ncon({P, P, P, delta}, {[-1, 1], [-2, 2], [-3, 3], [1, 2, 3]});
    end

    function a = construct_a(temperature)
      delta = Util.construct_delta();
      P = Util.construct_P(temperature);
      a = ncon({P, P, P, P, delta}, {[-1, 1], [-2, 2], [-3, 3], [-4, 4], [1, 2, 3, 4]});
    end

    function delta = construct_delta()
      delta = zeros(2, 2, 2, 2);
      delta(1, 1, 1, 1) = 1;
      delta(2, 2, 2, 2) = 1;
    end

    function delta = edge_delta()
      delta = zeros(2, 2, 2);
      delta(1, 1, 1) = 1;
      delta(2, 2, 2) = 2;
    end

    function delta = corner_delta()
      delta = zeros(2, 2);
      delta(1, 1) = 1;
      delta(2, 2) = 1;
    end

    function P = construct_P(temperature)
      % We need square root of a matrix here, not the square root of the elements!
      P = sqrtm(Util.construct_Q(temperature));
    end

    function Q = construct_Q(temperature)
      Q = [exp((1/temperature)*Constants.J) exp(-(1/temperature)*Constants.J); exp(-(1/temperature)*Constants.J) exp((1/temperature)*Constants.J)];
    end

    function Z = partition_function(temperature, C, T)
      Z = Util.attach_environment(Util.construct_a(temperature), C, T);
    end

    function result = attach_environment(tensor, C, T)
      env = Util.environment(C, T);
      result = ncon({tensor, env}, {[1 2 3 4], [1 2 3 4]});
    end

    function environment = environment(C, T)
      % Final order is such that the physical dimension of a quarter of the total
      % environment comes first. Second comes the T leg, third the C leg.
      quarter = ncon({C, T}, {[1, -1], [-2, 1, -3]}, [1], [-2 -3 -1]);
      % Final order is such that two physical dimensions come first, second the T leg,
      % third the C leg.
      half = ncon({quarter, quarter}, {[-1 1 -2], [-3 -4 1]}, [1], [-1 -3 -4 -2]);
      environment = ncon({half, half}, {[-1 -2 1 2], [-3 -4 2 1]});
    end

    function b = construct_b(temperature)
      g = Util.construct_g();
      P = Util.construct_P(temperature);
      b = ncon({P, P, P, P, g}, {[-1, 1], [-2, 2], [-3, 3], [-4, 4], [1, 2, 3, 4]});
    end

    function g = construct_g()
      g = Util.construct_delta();
      g(2, 2, 2, 2) = -1;
    end

    function [C, T] = deserialize_tensors(record)
      C = getArrayFromByteStream(record.c);
      T = getArrayFromByteStream(record.t);
    end

    function Ts = linspace_around_T_crit(width, number_of_points)
      Ts = linspace_around(Constants.T_crit, width, number_of_points);
    end

    function Ts = linspace_around_t(width, number_of_points)
      reduced_temperatures = linspace_around(0, width, number_of_points);
      Ts = Constants.inverse_reduced_Ts(reduced_temperatures);
    end

    function error = relative_error(true_value, estimate)
      error = (estimate - true_value) ./ abs(true_value);
    end

    function error = abs_relative_error(true_value, estimate)
      error  = abs( Util.relative_error(true_value, estimate) );
    end

    function [M, largest_element] = scale_by_largest_element(M)
      largest_element = max(M(:));
      M = M / largest_element;
    end

    function s = scale_singular_values(singular_values)
      % s = singular_values / sum(singular_values);
      s = singular_values / norm(singular_values);
      % [s, ~] = Util.scale_by_largest_element(singular_values);

    end

    function C = symmetrize_C(C)
      C = Util.symmetrize(C);
    end

    function T = symmetrize_T(T)
      % Why do we not symmetrize in the physical dimension?
      % Squeeze deletes the singleton dimension to obtain a chi x chi matrix.
      T(1,:,:) = Util.symmetrize(squeeze(T(1,:,:)));
      T(2,:,:) = Util.symmetrize(squeeze(T(2,:,:)));
    end

    function m = symmetrize(m)
      m = triu(m) + triu(m, 1)';
    end

    function C = grow_C(C, T, a)
      % Final order is specified so that the new tensor is ordered according to
      % [d, chi, d, chi], with the pairs of d, chi corresponding to what will be the reshaped
      % legs of the new C.

      % OLD
      % C = ncon({C, T, T, a}, {[1, 2], [3, 1, -1], [4, 2, -2], [3, -3, -4, 4]}, ...
      % [1, 2, 3, 4], [-3 -1 -4 -2]);

      % optimal sequence comes from netcon
      sequence = [2 3 1 4];
      C = ncon({a, T, C, T}, {[-1 1 4 -3], [1 2 -2], [2 3], [4 3 -4]}, sequence);
    end

    function T = grow_T(T, a)
      % Again, final order is chosen such that we have [d, chi, d, chi, d], i.e.
      % left legs, right legs, middle physical leg.
      T = ncon({T, a}, {[1 -2 -4], [1 -1 -5 -3]});
    end

    function C = truncate_C(C, U, U_transpose)
      C = ncon({C, U_transpose, U}, {[1 2 3 4], [1 2 -1], [3 4 -2]});
    end

    function T = truncate_T(T, U, U_transpose)
      % Again, keeping only chi most relevant eigenvectors, and being careful
      % to attach U first, so that U.U_transpose becomes a unity in the relevant
      % subspace when we construct the lattice later.
      % TODO: Why are U and U_transpose the same after the first step?
      % sequence = [1 4 2 3];
      T = ncon({T, U, U_transpose}, {[2 3 1 4 -1], [2 3 -2], [1 4 -3]}, [1 4 2 3]);
      % OLD
      % T = ncon({T, U, U_transpose}, {[1 2 3 4 -1], [1 2 -2], [3 4 -3]});
    end

    function [C, T, singular_values, truncation_error, full_singular_values, U, U_transpose] = grow_lattice(chi, a, C, T)
      C = Util.grow_C(C, T, a);
      [U, s, U_transpose, truncation_error, full_singular_values] = tensorsvd(C, [1 2], [3 4], chi, 'n');

      T = Util.grow_T(T, a);
      T = Util.truncate_T(T, U, U_transpose);

      singular_values = Util.scale_singular_values(diag(s));
      % We don't have to do this step:
      % C = Util.truncate_C(C, U, U_transpose);
      % This is equivalent:
      C = diag(singular_values);
    end

    function transfer_matrix = construct_transfer_matrix2(T)
      transfer_matrix = ncon({T, T}, {[1 -1 -3], [1 -2 -4]});
      transfer_matrix = lreshape(transfer_matrix, [1 2], [3 4]);
    end

    function transfer_matrix = construct_transfer_matrix(a, T)
      % Construct T - a - T
      transfer_matrix = ncon({T, a, T}, {[1 -1 -4], [1 -2 2 -5], [2 -3 -6]});

      % reshape into 2chi^2 x 2chi^2 matrix
      [transfer_matrix, ~, ~] = lreshape(transfer_matrix, [1 2 3], [4 5 6]);
    end

    function T_ball = construct_T_ball(b, T)
      % represents T - b - T, where represents summation over spin config
      % times spin eigenvalue on a site.
      T_ball = ncon({T, b, T}, {[1 -1 -4], [1 -2 2 -5], [2 -3 -6]});
      % reshape into 2chi^2 x 2chi^2 matrix
      [T_ball, ~, ~] = lreshape(T_ball, [1 2 3], [4 5 6]);
    end

    % function x = multiply_by_transfer_matrix(a, T, x)
    %   chi = size(T, 2);
    %   x = reshape(x, chi, 2, chi);
    %   % best sequence: 2 1 3 4 5
    %   x = ncon({T, a, T, x}, {[1 -1 2], [1 3 4 -2], [4 5 -3], [2 3 5]}, [2 1 3 4 5]);
    %   x = x(:);
    % end
    %
    % function [eigenvectors, eigenvalues] = largest_eigenvalues_transfer_matrix(a, T, number_of_eigenvalues)
    %   % Diagonalize using a custom function to multiply T*x
    %   chi = size(T, 2);
    %   transfer_matrix_size = 2 * chi * chi;
    %
    %   function x = multiply_by_transfer_matrix(x)
    %     x = Util.multiply_by_transfer_matrix(a, T, x);
    %   end
    %
    %   [eigenvectors, diagonal] = eigs(@multiply_by_transfer_matrix, ...
    %     transfer_matrix_size, number_of_eigenvalues);
    %   eigenvalues = diag(diagonal);
    %   % Let's not sort this here; the order of eigenvectors gets messed up.
    %   % eigenvalues = sort(diag(diagonal), 'descend');
    %
    %   if number_of_eigenvalues > 1
    %     if IsNear(eigenvalues(1), eigenvalues(2), 1e-10)
    %       warning(['degenerate largest eigenvalue of transfer matrix for T = ' num2str(temperature)])
    %     end
    %   end
    % end

    function s = initial_singular_values(chi)
      s = ones(chi, 1) / chi;
    end

    function c = calculate_convergence(singular_values, singular_values_old, chi)
      % TODO: something weird happened last time: when calculating correlation length
      % for T >> Tc, I found that the T tensor did not have the right dimension.

      % Sometimes it happens that the current singular values vector is smaller
      % than the old one, because MATLAB's svd procedure throws away excessively
      % small singular values. The code below adds zeros to singular_values to match
      % the dimension of singular_values_old.
      if size(singular_values, 1) < chi
        singular_values(chi) = 0;
      end

      % If chi_init is small enough, the bond dimension of C and T will not exceed
      % chi for the first few steps.
      if size(singular_values_old, 1) < chi
        singular_values_old(chi) = 0;
      end

      c = sum(abs(singular_values - singular_values_old));
    end
  end
end
