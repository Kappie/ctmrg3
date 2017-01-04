function data_collapse_free_energy
  temperatures = Constants.T_crit;
  chi_values = 2:1:50;
  tolerance = 1e-7;

  correlation_lengths = zeros(1, numel(chi_values));
  for c = 1:numel(chi_values)
    correlation_lengths(c) = calculate_correlation_length(Constants.T_crit, chi_values(c), tolerance);
  end

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance).run();
  free_energies = sim.compute(FreeEnergy);
  order_params = sim.compute(OrderParameter);
  diffs = free_energies - Constants.free_energy_per_site(temperatures);

  beta = 1/8; nu = 1;
  rho = 2;
  % scaling_function_values = diffs .* correlation_lengths.^(rho/nu);
  scaling_function_values = order_params .* correlation_lengths .^ (beta/nu)
  markerplot(chi_values, scaling_function_values, '--')

  xlabel('$\chi$')
  ylabel('$\Delta f(t = 0, \chi)\xi(\chi)^{d}$')
  % scaling_function_values = order_params .* correlation_lengths.^(beta/nu);
  % markerplot(chi_values, diffs, '--', 'loglog');
  % markerplot(correlation_lengths, diffs, '--', 'loglog')
  % [slope, intercept, mse] = logfit(correlation_lengths, diffs, 'loglog', 'skipBegin', 2)

end
