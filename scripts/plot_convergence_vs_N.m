function plot_convergence_vs_N
  q = 2;
  temperature = Constants.T_crit_guess(q);
  max_N = 3e5;
  number_of_data_points = 150;
  step_size = fix(max_N/number_of_data_points);
  N_values = step_size:step_size:max_N;
  chi_values = [10 18 26 34];
  % N = 10000;
  % chi_values = [10 12];
  initial_condition = 'spin-up';
  TolX_T_pseudocrit = 1e-6;

  sim_T_crit = FindTCritFixedChi(q, TolX_T_pseudocrit, chi_values).run();
  T_pseudocrits = sim_T_crit.T_pseudocrits;
  convergences = zeros(numel(N_values), numel(chi_values));

  for i = 1:numel(T_pseudocrits)
    sim = FixedNSimulation(T_pseudocrits(i), chi_values(i), N_values, q).run();
    convergences(:, i) = sim.convergences;
  end


  plot(N_values, convergences)
  xlabel('$n$')
  ylabel('convergence')
  set(gca, 'YScale', 'log')
  set(gca, 'XScale', 'log')
  make_legend(chi_values, '\chi')
  % legend({'convergence', 'order parameter'})

end
