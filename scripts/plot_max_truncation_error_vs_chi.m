function plot_max_truncation_error_vs_chi
  q = 2;
  temperature = Constants.T_crit_guess(q);
  % N_values = [200 600 1000 2200 8000];
  % N_values = [200 1000 2200 8000];
  N_values = [50 8000];

  chi_difference = 20;
  chi_values = chi_difference:chi_difference:280;
  % chi_values = [5, 7, 10, 14, 19, 25, 33, 43, 55, 70, 88, 110, 137, 169, 207];
  % chi_values = [5, 7, 10, 14, 19, 25, 33, 43, 55, 70, 88];
  % correlation_lengths = calculate_correlation_lengths(Constants.T_crit, chi_values, 1e-7, q, 'spin-up');
  % save('correlation_lengths_plateau_values.mat', 'chi_values', 'correlation_lengths')
  % load('correlation_lengths_plateau_values.mat', 'chi_values', 'correlation_lengths')

  initial_condition = 'spin-up';
  TolX = 1e-6;

  % sim_T_pseudocrit = FindTCritFixedN(q, TolX, N_values).run();
  % T_pseudocrits = sim_T_pseudocrit.T_pseudocrits;
  % truncation_errors = zeros(numel(chi_values), numel(N_values));
  % order_parameters = zeros(numel(chi_values), numel(N_values));

  % for i = 1:numel(T_pseudocrits)
  %
  %   sim = FixedNSimulation(T_pseudocrits(i), chi_values, N_values(i), q).run();
  %   error_structs = sim.compute('truncation_error');
  %   truncation_errors(:, i) = arrayfun(@(error_struct) error_struct.truncation_error, error_structs);
  %   order_parameters(:, i) = sim.compute('order_parameter');
  % end

  sim = FixedNSimulation(temperature, chi_values, N_values, q).run();
  truncation_errors = sim.truncation_errors
  free_energies = sim.compute('free_energy');
  order_parameters = sim.compute('order_parameter');

  [extrapolations, residues, relative_errors, rel_error_pct] = extrapolate_quantity_finite_N(order_parameters, ...
    chi_values, chi_difference)



  % figure
  % markerplot(chi_values(2:end), stepwise_diffs, '--', 'loglog')
  % make_legend(N_values, 'N')
  % xlabel('$\chi$')
  % ylabel('stepwise diff')

end


function [extrapolations, residues, relative_errors, relative_errors_percentage]= extrapolate_quantity_finite_N(...
  quantities, chi_values, chi_difference)

  stepwise_diffs = absolute_stepwise_differences(quantities');
  number_of_N_values = size(quantities, 2);
  chi_values_to_sum = chi_difference:chi_difference:(30*chi_difference);
  chi_values_to_sum = chi_values_to_sum + chi_values(end)

  residues = zeros(1, number_of_N_values);

  for n = 1:number_of_N_values
    figure
    [slope, intercept, mse] = logfit(chi_values(2:end), stepwise_diffs(n, :), 'loglog');
    title(num2str(n))
    residues(n) = sum(arrayfun( @(chi) 10^intercept * chi^slope, chi_values_to_sum ) );
  end

  extrapolations = quantities(end, :) + residues;
  relative_errors = residues ./ extrapolations;
  relative_errors_percentage = 100*relative_errors;
end
