function plot_convergence_vs_N
  q = 2;
  temperature = Constants.T_crit_guess(q);
  max_N = 1e5;
  number_of_data_points = 50;
  step_size = fix(max_N/number_of_data_points);
  N_values = step_size:step_size:max_N;
  chi_values = [10 18 26 34 42 50];
  % N = 10000;
  % chi_values = [10 12];
  initial_condition = 'spin-up';
  TolX_T_pseudocrit = 1e-6;

  % sim_T_crit = FindTCritFixedChi(q, TolX_T_pseudocrit, chi_values).run();
  % T_pseudocrits = sim_T_crit.T_pseudocrits;
  % convergences = zeros(numel(N_values), numel(chi_values));
  % order_parameters = zeros(numel(N_values), numel(chi_values));

  % for i = 1:numel(T_pseudocrits)
  %   sim = FixedNSimulation(T_pseudocrits(i), chi_values(i), N_values, q).run();
  %   convergences(:, i) = sim.convergences;
  %   order_parameters(:, i) = sim.compute('order_parameter');
  % end

  sim = FixedNSimulation(temperature, chi_values, N_values, q).run();
  convergences = sim.convergences;
  order_parameters = sim.compute('order_parameter');
  free_energies = sim.compute('free_energy');
  % correlation_lengths = sim.compute('correlation_length');
  entropies = sim.compute('entropy');

  x_scale = 'linear';
  y_scale = 'log';

  % figure
  % plot(N_values, convergences)
  % xlabel('$n$')
  % ylabel('convergence')
  % set(gca, 'XScale', x_scale)
  % set(gca, 'YScale', y_scale)
  % make_legend(chi_values, '\chi')

  % figure
  % diffs = relative_diffs_with_smallest_value(order_parameters)
  % plot(N_values, diffs)
  % xlabel('$n$')
  % ylabel('order parameter')
  % set(gca, 'XScale', x_scale)
  % set(gca, 'YScale', y_scale)
  % make_legend(chi_values, '\chi')
  %
  % figure
  % diffs = abs(relative_diffs_with_smallest_value(free_energies))
  % plot(N_values, diffs)
  % xlabel('$n$')
  % ylabel('free energy diff')
  % set(gca, 'XScale', x_scale)
  % set(gca, 'YScale', y_scale)
  % make_legend(chi_values, '\chi')

  % figure
  % diffs = relative_diffs_with_biggest_value(entropies)
  % plot(N_values, abs(diffs))
  % xlabel('$n$')
  % ylabel('entropy')
  % set(gca, 'XScale', x_scale)
  % set(gca, 'YScale', y_scale)
  % make_legend(chi_values, '\chi')

  figure
  diffs = relative_diffs_with_biggest_value(correlation_lengths)
  plot(N_values, abs(diffs))
  xlabel('$n$')
  ylabel('correlation length')
  set(gca, 'XScale', x_scale)
  set(gca, 'YScale', y_scale)
  make_legend(chi_values, '\chi')
end

function diffs = relative_diffs_with_smallest_value(quantities)
  [~, indices_min] = min(quantities, [], 2);
  for i = 1:size(quantities, 1)
    smallest_values = quantities(i, indices_min(i));
    diffs(i , :) = (quantities(i, :) - smallest_values) ./ smallest_values;
  end
end

function diffs = relative_diffs_with_biggest_value(quantities)
  [~, indices_max] = max(quantities, [], 2);
  for i = 1:size(quantities, 1)
    biggest_values = quantities(i, indices_max(i));
    diffs(i , :) = (quantities(i, :) - biggest_values) ./ biggest_values;
  end
end
