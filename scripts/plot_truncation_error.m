function plot_truncation_error
  width = 1;
  chi = 24
  chi_values = [27];
  diff = Constants.T_pseudocrit(chi) - Constants.T_crit;
  temperatures = linspace(Constants.T_crit, Constants.T_crit + 2*diff, 10);
  tolerances = [1e-7];

  % final index for both boundary conditions
  truncation_errors = zeros(numel(temperatures), numel(chi_values), 2);

  for t = 1:numel(temperatures)
    for c = 1:numel(chi_values)
      truncation_errors(t, c, 1) = calculate_truncation_error(temperatures(t), chi_values(c), tolerances, 'spin-up');
      truncation_errors(t, c, 2) = calculate_truncation_error(temperatures(t), chi_values(c), tolerances, 'symmetric');
    end
  end

  % markerplot(1:numel(chi_values), [0.05./truncation_errors; correlation_lengths], '--')
  markerplot(temperatures, squeeze(truncation_errors), '--')
  legend({'spin-up', 'symmetric'}, 'Location', 'best')
  % make_legend(chi_values, '\chi')
  truncation_errors

  % [slope, intercept] = logfit(truncation_errors, correlation_lengths, 'loglog', 'skipBegin', 5)
end

function truncation_error = calculate_truncation_error(temperature, chi, tolerance, initial_condition)
  sim = FixedToleranceSimulation(temperature, chi, tolerance);
  sim.initial_condition = initial_condition;
  sim = sim.run();
  tensors = sim.tensors;

  a = sim.a_tensors(temperature);
  [C, T, singular_values, truncation_error, full_singular_values] = sim.grow_lattice( ...
    chi, a, tensors.C, tensors.T);
end
