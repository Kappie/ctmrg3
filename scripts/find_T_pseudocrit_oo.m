function find_T_pseudocrit_oo
  q = 2;
  N_values = 20:20:500;
  TolX = 1e-6;

  sim = FindTCritFixedN(q, TolX, N_values);
  sim.chi_start = 100;
  sim = sim.run();
  sim.T_pseudocrits
  sim.truncation_errors

  % markerplot(N_values, sim.T_pseudocrits, '--');

  model_name = 'power2';
  fit_options = fitoptions(model_name, 'Lower', [0 -10 2.25], ...
    'Upper', [Inf 0 2.28], 'Startpoint', [1 -1 Constants.T_crit], 'Exclude', N_values < 200);
  [fit_obj, goodness] = fit(N_values', sim.T_pseudocrits', model_name, fit_options)
  markerplot(N_values, sim.T_pseudocrits - fit_obj.c, 'None')
  hold on
  values_to_plot = linspace(N_values(1), N_values(end));
  plot(values_to_plot, fit_obj.a.*values_to_plot.^fit_obj.b)
  hold off
  set(gca, 'XScale', 'log')
  set(gca, 'YScale', 'log')
end
