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
  correlation_lengths = sim.compute('correlation_length');

  x_scale = 'log';
  y_scale = 'log';

  figure
  plot(N_values, convergences)
  xlabel('$n$')
  ylabel('convergence')
  set(gca, 'XScale', x_scale)
  set(gca, 'YScale', y_scale)
  make_legend(chi_values, '\chi')

  figure
  plot(N_values, order_parameters)
  xlabel('$n$')
  ylabel('order parameter')
  set(gca, 'XScale', x_scale)
  set(gca, 'YScale', y_scale)
  make_legend(chi_values, '\chi')
  % legend({'convergence', 'order parameter'})
  figure
  plot(N_values, free_energies - Constants.free_energy_per_site(temperature))
  xlabel('$n$')
  ylabel('free energy')
  set(gca, 'XScale', x_scale)
  set(gca, 'YScale', y_scale)
  make_legend(chi_values, '\chi')

  figure
  plot(N_values, correlation_lengths)
  xlabel('$n$')
  ylabel('correlation length')
  set(gca, 'XScale', x_scale)
  set(gca, 'YScale', y_scale)
  make_legend(chi_values, '\chi')

end
