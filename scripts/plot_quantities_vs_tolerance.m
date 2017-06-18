function plot_quantities_vs_tolerance
  q = 2;
  temperature = Constants.T_crit_guess(q);
  % chi_values = [10 20 30 40 60 80 100 120];
  % chi_values = [10 20 30 40 60 80 100 120];
  % chi_values = [10 32 60 120];
  chi_values = [40 80 120];
  % tolerances = [1e-5 1e-6 1e-7 1e-8 1e-9 1e-10 1e-11 1e-12];
  % tolerances = [7e-5 3e-5 1e-5 7e-6 3e-6 1e-6 7e-7 3e-7 1e-7];
  tolerances = [32 16 8 4 2 1] .* 1e-8;
  multiplier = 2;

  sim = FixedToleranceSimulation(temperature, chi_values, tolerances, q).run();
  order_parameters = sim.compute('order_parameter');
  free_energies = sim.compute('free_energy');
  entropies = sim.compute('entropy');
  correlation_lengths = sim.compute('correlation_length');
  truncation_error_structs = sim.compute('truncation_error');
  truncation_errors = arrayfun(@(s) s.truncation_error, truncation_error_structs);

  display('order params')
  [extrapolations, residues, relative_errors] = extrapolate_quantity(order_parameters, tolerances, multiplier)
  display('entropies')
  [extrapolations, residues, relative_errors] = extrapolate_quantity(entropies, tolerances, multiplier)
  display('correlation_lengths')
  [extrapolations, residues, relative_errors] = extrapolate_quantity(correlation_lengths, tolerances, multiplier)

  % figure
  % % diffs = relative_diffs_with_last_element(order_parameters)

  % diffs = -(order_parameters - circshift(order_parameters, 1, 2)) ./ order_parameters(:, end);
  % diffs_truncation_error = (truncation_errors - circshift(truncation_errors, 1, 2)) ./ truncation_errors(:, end);
  % % diffs = (correlation_lengths - circshift(correlation_lengths, 1, 2)) ./ correlation_lengths(:, end);
  % % diffs = (entropies - circshift(entropies, 1, 2));
  % % diffs = (free_energies - circshift(free_energies, 1, 2));
  % diffs = diffs(:, 2:end)
  % diffs_truncation_error = diffs_truncation_error(:, 2:end)


  % figure
  % markerplot(truncation_errors, order_parameters, '--')

  % figure
  % markerplot(diffs_truncation_error', diffs', '--', 'loglog')
  % make_legend(chi_values, '\chi')
  % markerplot(diffs_truncation_error, tolerances(2:end), '--', 'loglog')
  % make_legend(chi_values, '\chi')
  % markerplot(truncation_errors(1, :), order_parameters(1, :), '--')
  % markerplot(tolerances(2:end), diffs, '--', 'loglog')
  % make_legend(chi_values, '\chi')
  % xlabel('tolerance')
  % ylabel('$\Delta M$')

  % figure
  % [slope, intercept, mse] = logfit(tolerances(2:end), diffs(1,:), 'loglog')
  % diffs



  %
  % figure
  % diffs = relative_diffs_with_last_element(free_energies)
  % markerplot(tolerances, abs(diffs), '--', 'loglog')
  % make_legend(chi_values, '\chi')
  % xlabel('tolerance')
  % ylabel('$\Delta f$')
  % %
  % figure
  % diffs = relative_diffs_with_last_element(entropies)
  % markerplot(tolerances, abs(diffs), '--', 'loglog')
  % make_legend(chi_values, '\chi')
  % xlabel('tolerance')
  % ylabel('$\Delta S$')
  %
  % figure
  % diffs = relative_diffs_with_last_element(correlation_lengths)
  % markerplot(tolerances, abs(diffs), '--', 'loglog')
  % make_legend(chi_values, '\chi')
  % xlabel('tolerance')
  % ylabel('$\Delta \xi$')
end

function [extrapolations, residues, relative_errors] = extrapolate_quantity(quantities, tolerances, multiplier)
  stepwise_diffs = absolute_stepwise_differences(quantities);
  number_of_chi_values = size(quantities, 2);
  tolerances_to_sum = tolerances(end) ./ (multiplier .^ 1:10);

  residues = zeros(1, number_of_chi_values);

  for c = 1:number_of_chi_values
    figure
    [slope, intercept, mse] = logfit(tolerances(2:end), stepwise_diffs(:, c), 'loglog');
    residues(c) = sum(arrayfun( @(epsilon) 10^intercept * epsilon^slope, tolerances_to_sum ) );
  end

  extrapolations = quantities(end, :) + residues;
  relative_errors = residues ./ extrapolations;
end
