function plot_truncation_error
  width = 1.0;
  temperatures = Constants.T_crit + [width];
  chi_values = 2:2:128;
  tolerances = [1e-7];

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances).run();
  tensors = sim.tensors;

  truncation_errors = zeros(numel(temperatures), numel(chi_values));
  % correlation_lengths = sim.compute(CorrelationLength);

  for t = 1:numel(temperatures)
    for c = 1:numel(chi_values)
      a = sim.a_tensors(temperatures(t));
      [C, T, singular_values, truncation_error, full_singular_values] = sim.grow_lattice( ...
        chi_values(c), a, tensors(t, c).C, tensors(t, c).T);
      truncation_errors(t, c) = truncation_error;
    end
  end

  % markerplot(1:numel(chi_values), [0.05./truncation_errors; correlation_lengths], '--')
  markerplot(chi_values, truncation_errors, '--', 'semilogy')
  make_legend(temperatures, 'T')
  truncation_errors

  % [slope, intercept] = logfit(truncation_errors, correlation_lengths, 'loglog', 'skipBegin', 5)
end
