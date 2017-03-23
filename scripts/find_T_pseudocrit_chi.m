function find_T_pseudocrit_chi
  q = 2;
  chi_values = [10 12 14 20 30 33 38 43 49 56];
  TolX = 1e-6;

  % For power law fitting
  TolXFit = 1e-14;
  search_width = 0.02;

  sim = FindTCritFixedChi(q, TolX, chi_values).run();
  sim.T_pseudocrits
  sim.length_scales

  % [slope, intersect] = logfit(1./sim.length_scales, sim.T_pseudocrits - Constants.T_crit, 'loglog')

  [T_crit, mse, ~] = fit_power_law(sim.length_scales, sim.T_pseudocrits, search_width, TolXFit)

  % markerplot(sim.length_scales, sim.T_pseudocrits - T_crit, '--')

  % markerplot(chi_values, sim.length_scales, '--', 'loglog');
  % sim.T_pseudocrits

  % logfit(exp(sim.length_scales), sim.T_pseudocrits - Constants.T_crit, 'loglog')

  % markerplot(sim.length_scales, sim.T_pseudocrits - Constants.T_crit, '--', 'loglog')
  % model_name = 'power2';
  % fit_options = fitoptions(model_name, 'Lower', [0 -2 2.2], ...
  %   'Upper', [Inf 0 2.3], 'Startpoint', [1 -1 Constants.T_crit_guess(q)], 'Exclude', chi_values < 20);
  % [fit_obj, goodness] = fit(sim.length_scales', sim.T_pseudocrits', model_name, fit_options)
  % plot(fit_obj, sim.length_scales, sim.T_pseudocrits)
  % markerplot(sim.length_scales, sim.T_pseudocrits, 'None')
  % hold on
  % values_to_plot = linspace(sim.length_scales(1), sim.length_scales(end));
  % plot(values_to_plot, fit_obj.a.*values_to_plot.^fit_obj.b)
  % hold off
  % set(gca, 'XScale', 'log')
  % set(gca, 'YScale', 'log')
end
