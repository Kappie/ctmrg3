function plot_truncation_error_vs_n
  temperatures = Constants.T_crit;
  chi_values = [5 10 40];
  tolerances = [1e-5 1e-6 1e-7 1e-8 1e-9];
  q = 2;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances, q);
  sim = sim.run();
  truncation_errors_struct = sim.compute('truncation_error');
  truncation_errors = arrayfun(@(s) s.truncation_error, truncation_errors_struct);
  order_parameters = sim.compute('order_parameter');
  correlation_lengths = sim.compute('correlation_length');
  free_energies = sim.compute('free_energy');
  entropies = sim.compute('entropy');

  % getallen = [0.4 0.38 0.371 0.371001 0.371001005]'
  % relative_differences_with_end(getallen)

  rel_diffs_truncation_error = relative_differences_with_end(truncation_errors)
  rel_diffs_order_parameter = relative_differences_with_end(order_parameters);
  % rel_diffs_correlation_length = relative_differences_with_end(correlation_lengths);
  rel_diffs_entropy = relative_differences_with_end(entropies)
  rel_diffs_free_energy = relative_differences_with_end(free_energies)

  markerplot(tolerances(2:end), relative_stepwise_differences(correlation_lengths), '--', 'loglog')

  % figure
  % hold on
  % % markerplot(N_values(1:(end-1)), relative_differences_with_end(order_parameters), '--', 'semilogy')
  % % markerplot(N_values(1:(end-1)), relative_differences_with_end(correlation_lengths), '--', 'semilogy')
  % % markerplot(N_values(1:(end-1)), sqrt(relative_differences_with_end(free_energies)), '--', 'semilogy')
  % % markerplot(N_values(1:(end-1)), relative_differences_with_end(entropies), '--', 'semilogy')
  % % markerplot(N_values(1:(end-1)), relative_differences_with_end(truncation_errors), '--', 'semilogy')
  % markerplot(rel_diffs_truncation_error, rel_diffs_free_energy, '--')
  % % markerplot(rel_diffs_truncation_error, rel_diffs_correlation_length, '--')
  % hold off
  % set(gca, 'YScale', 'log')
  % set(gca, 'XScale', 'log')
  % % legend({'$M$', '$P$'})
  %
  % figure
  % % [slope, intercept, mse] = logfit(rel_diffs_truncation_error(:, 1), rel_diffs_entropy(:, 1), 'loglog')
  % [slope, intercept, mse] = logfit(rel_diffs_truncation_error(:, end), rel_diffs_free_energy(:, end), 'loglog')


end


function rel_diffs = relative_differences_with_end(quantities)
  rel_diffs = abs((quantities - quantities(end, :)) ./ quantities(end, :));
  rel_diffs = rel_diffs(1:(end-1), :)
end
