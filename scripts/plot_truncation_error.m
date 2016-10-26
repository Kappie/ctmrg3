function plot_truncation_error
  temperatures = [Constants.T_crit];
  chi_values = 6:1:16;
  tolerances = [1e-7];

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances).run();
  tensors = sim.tensors;

  truncation_errors = zeros(1, numel(chi_values));
  correlation_lengths = sim.compute(CorrelationLength);

  for c = 1:numel(chi_values)
    [C, T, singular_values, truncation_error, full_singular_values] = sim.grow_lattice( ...
      temperatures(1), chi_values(c), tensors(c).C, tensors(c).T);
    truncation_errors(c) = truncation_error;
  end

  markerplot(1:numel(chi_values), [0.05./truncation_errors; correlation_lengths])
  % [slope, intercept] = logfit(truncation_errors, correlation_lengths, 'loglog', 'skipBegin', 5)
end
