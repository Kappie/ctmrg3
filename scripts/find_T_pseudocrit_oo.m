function find_T_pseudocrit_oo
  % Simulation parameters
  q = 6;
  % N_values = 60:10:80;
  % N_values = [10:5:70 80:10:120];
  N_values = [10:5:85];
  % TolX = 1e-5;
  TolX = 1e-5;

  sim = FindTCritFixedN(q, TolX, N_values);
  sim.max_truncation_error = 1e-5;
  sim.chi_start = 200;
  sim.initial_condition = 'spin-up';
  % sim.initial_condition = 'symmetric';
  sim.T_crit_range = [0.6 0.65];
  sim = sim.run();

  % Fit parameters
  TolXFit = 1e-10;
  N_min = 60;
  exclude = N_values < N_min;
  T_crit_guess = 0.90
  search_width = 3e-2;
  skipBegin = 0;

  % entropies = sim.compute('entropy');

  % [slope, intercept, mse] = logfit(N_values, entropies, 'logx', 'skipBegin', skipBegin)
  % central_charge = 6*slope

  % [T_crit, mse] = fit_power_law3(N_values, sim.T_pseudocrits, exclude, search_width, TolXFit)
  % xlabel('$N$')
  % ylabel('$T^{*}(N)$')
  % title(['Fit to $T^{*}(N)$ for second order transition for $q = ' num2str(q) '$ clock model.'])
  % sim.T_pseudocrits
  [T_crit, mse, ~] = fit_kosterlitz_transition2(sim.T_pseudocrits, N_values, exclude, T_crit_guess, ...
    search_width, TolXFit)
  xlabel('$1/\ell$')
  ylabel('$T^{*}(N)$')
  title(['Fit to $T^{*}(N)$ for BKT-transition for $q = ' num2str(q) '$ clock model.'])

  % markerplot(N_values, sim.T_pseudocrits, '--');

  % model_name = 'power2';
  % fit_options = fitoptions(model_name, 'Lower', [0 -1.004 2.269], ...
  %   'Upper', [10 -0.996 2.270], 'Startpoint', [1 -1 Constants.T_crit], 'Exclude', N_values < 300);
  % [fit_obj, goodness] = fit(N_values', sim.T_pseudocrits', model_name, fit_options)
  % plot(fit_obj, N_values, sim.T_pseudocrits)
  % markerplot(N_values, sim.T_pseudocrits - fit_obj.c, 'None')
  % hold on
  % values_to_plot = linspace(N_values(1), N_values(end));
  % plot(values_to_plot, fit_obj.a.*values_to_plot.^fit_obj.b)
  % hold off
  % set(gca, 'XScale', 'log')
  % set(gca, 'YScale', 'log')
end
