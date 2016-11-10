function correlation_function
  % temperatures = Constants.T_crit + [0.0005 0.001 0.005 0.01, 0.02];
  temperatures = Constants.T_crit + [0.01];
  % temperatures = 1;
  chi_values = [8 16 24 32 48];
  % chi_values = 4;
  tolerance = 1e-8;
  steps = 50;
  skip_begin = 0;
  warmup_steps = 200;

  correlators = zeros(numel(temperatures), numel(chi_values), steps);
  slopes = zeros(numel(temperatures), numel(chi_values));
  fit_errors = zeros(numel(temperatures), numel(chi_values));
  corr_lengths = zeros(numel(temperatures), numel(chi_values));
  % magnetizations = zeros(1, steps);


  for t = 1:numel(temperatures)

    for c = 1:numel(chi_values)

      sim = FixedToleranceSimulation(temperatures(t), chi_values(c), tolerance).run();
      converged_tensors = sim.tensors;
      [C, T, T_b] = grow_lattice_and_construct_T_b(temperatures(t), chi_values(c), converged_tensors.C, converged_tensors.T);

      % Warmup steps
      for n = 1:warmup_steps
        [C, T, T_b] = grow_lattice_and_T_b(temperatures(t), chi_values(c), C, T, T_b);
      end

      % measure steps
      for n = 1:steps
        correlators(t, c, n) = correlator(temperatures(t), C, T, T_b);
        [C, T, T_b] = grow_lattice_and_T_b(temperatures(t), chi_values(c), C, T, T_b);
      end

      % points_used = 20;

      % [slopes(t, c), ~, fit_errors(t, c)] = logfit(1:steps, correlators(t, c,:), 'logy', 'skipBegin', steps-points_used);
      % [slopes(t, c), ~, fit_errors(t, c)] = logfit(1:steps, correlators(t, c,:), 'logy', 'skipBegin', skip_begin);
      [graph_type, slopes(t, c), ~, fit_errors(t, c)] = logfit(1:steps, correlators(t, c,:));
      graph_type
      corr_lengths(t, c) = sim.compute(CorrelationLength2);
    end

  end

  fit_errors


  subplot(2, 1, 1)
  corr_lengths_fit = -1./slopes;
  corr_lengths_fit ./ 2 - corr_lengths
  markerplot(chi_values, [corr_lengths_fit; corr_lengths], '--')
  hline(Constants.correlation_length(temperatures(1)), '--')
  xlabel('$\chi$')
  ylabel('$\xi$')
  legend({'fit from correlator', 'from transfer matrix'}, 'Location', 'best')

  % subplot(3, 1, 2)
  % markerplot(chi_values, squeeze(fit_errors), '--', 'semilogy')
  %
  % xlabel('$\chi$')
  % ylabel('fit error')

  subplot(2, 1, 2)

  correlators = squeeze(correlators);
  semilogy(1:steps, correlators)
  xlabel('$\ell$')
  ylabel('$\left< s_0 s_{\ell} \right> - \left<s_0 \right>^2$')
  % make_legend(Constants.reduced_Ts(temperatures), 't')
  make_legend(chi_values, '\chi')
end

function [C, T, T_b] = grow_lattice_and_T_b(temperature, chi, C, T, T_b)
  [C, T, ~, ~, ~, U, U_transpose] = Util.grow_lattice(temperature, chi, C, T);
  T_b = grow_T_b(temperature, T_b, U, U_transpose);

  [C, scale_factor] = Util.scale_by_largest_element(C);
  T = T / scale_factor;
  T_b = T_b / scale_factor;
  C = Util.symmetrize_C(C);
  T = Util.symmetrize_T(T);
  T_b = Util.symmetrize_T(T_b);
end

function T_b = grow_T_b(temperature, T_b, U, U_transpose)
  T_b = Util.grow_T(T_b, Util.construct_a(temperature));
  T_b = Util.truncate_T(T_b, U, U_transpose);
end

% grow lattice function which also returns Tb, a transfer matrix with a b-tensor,
% i.e. a boltzmann weight times spin value at a particular site.
% Requires converged C, T tensors to work properly.
function [C, T, T_b] = grow_lattice_and_construct_T_b(temperature, chi, C, T)
  [C, T, ~, ~, ~, U, U_transpose] = Util.grow_lattice(temperature, chi, C, T);
  % Now, we construct a T-tensor with an added b-tensor.
  % the b-tensor represents an operator that measures the spin at that site.
  % Again, we choose the order such that [d, chi, d, chi, d], where the final
  % d represents the middle physical leg (is this optimal???)
  T_b = ncon({T, Util.construct_b(temperature)}, {[1 -2 -4], [1 -1 -5 -3]});
  T_b = Util.truncate_T(T_b, U, U_transpose);

  % Scale elements to prevent values from diverging when performing numerous growth steps.
  % Resymmetrize to prevent numerical errors adding up to unsymmetrize tensors.
  % Take care to scale T_b with the same value as T! Otherwise we do not have a valid
  % expectation value later.
  [C, scale_factor] = Util.scale_by_largest_element(C);
  T = T / scale_factor;
  T_b = T_b / scale_factor;
  C = Util.symmetrize_C(C);
  T = Util.symmetrize_T(T);
  T_b = Util.symmetrize_T(T_b);
end

function value = correlator(temperature, C, T, T_b)
  norm = Util.partition_function(temperature, C, T);
  % subtract product of expectation values of separate spins (is this ok?)
  % they are not necessarily the same, though in a sufficiently converged environment, they are.

  corr = unnormalized_correlator(temperature, C, T, T_b);
  corr = corr/norm;
  value = corr - Magnetization.value_at(temperature, C, T)^2;
end

function correlator = unnormalized_correlator(temperature, C, T, T_b)
  % Final order is such that the physical dimension of a quarter of the total
  % environment comes first. Second comes the T leg, third the C leg.
  quarter = ncon({C, T}, {[1 -3], [-1 1 -2]});
  quarter_b = ncon({C, T_b}, {[1 -3], [-1 1 -2]});
  % Final order is such that two physical dimensions come first, second the T leg,
  % third the C leg.
  half = ncon({quarter, quarter}, {[-1 1 -4], [-2 -3 1]});
  half_b = ncon({quarter, quarter_b}, {[-1 1 -4], [-2 -3 1]});

  environment = ncon({half, half_b}, {[-1 -2 1 2], [-3 -4 2 1]});

  % attach final b-tensor in the middle
  correlator = ncon({Util.construct_b(temperature), environment}, {[1 2 3 4], [1 2 3 4]});
end
