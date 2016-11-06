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

    function error = relative_error(true_value, estimate)
      error = (estimate - true_value) ./ true_value;
    end

    function error = abs_relative_error(true_value, estimate)
      error  = abs( Util.relative_error(true_value, estimate) );
    end

    function [M, largest_element] = scale_by_largest_element(M)
      largest_element = max(M(:));
      M = M / largest_element;
    end

    function s = scale_singular_values(singular_values)
      s = singular_values / sum(singular_values);
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
  end
end
