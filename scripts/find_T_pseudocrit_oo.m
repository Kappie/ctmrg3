function find_T_pseudocrit_oo
  q = 4;
  N_values = 20:20:400;
  TolX = 1e-6;

  sim = FindTCritFixedN(q, TolX, N_values);
  sim.chi_start = 200;
  sim = sim.run();
  sim.T_pseudocrits
  sim.truncation_errors

  markerplot(N_values, sim.T_pseudocrits, '--');
  hline(Constants.T_crit);

  model_name = 'power2'
  fit_options = fitoptions(model_name, 'Lower', [0 -10 2.25], ...
    'Upper', [Inf 0 2.28], 'Startpoint', [1 -1 Constants.T_crit], 'Exclude', N_values < 200);
  [fit_obj, goodness] = fit(N_values', sim.T_pseudocrits', model_name, fit_options)
  plot(fit_obj, N_values, sim.T_pseudocrits)
end
