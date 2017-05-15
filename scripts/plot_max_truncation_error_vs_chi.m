function plot_max_truncation_error_vs_chi
  q = 2;
  temperature = Constants.T_crit_guess(q);
  N_values = [60 200 600 2200];
  chi_values = 2:1:100;
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
  % truncation_errors = arrayfun(@(error_struct) error_struct.truncation_error, sim.truncation_errors);
  truncation_errors = sim.truncation_errors;
  order_parameters = sim.compute('order_parameter');
  % error_structs = sim.compute('truncation_error');
  % truncation_errors = arrayfun(@(error_struct) error_struct.truncation_error, error_structs);
  % order_parameters = sim.compute('order_parameter');
  figure
  markerplot(chi_values, truncation_errors, '--', 'semilogy')
  ylabel('truncation error')
  xlabel('$\chi$')
  make_legend(N_values, 'N')
  figure
  markerplot(chi_values, order_parameters, '--', 'loglog')
  ylabel('M')
  xlabel('$\chi$')
  make_legend(N_values, 'N')


end
