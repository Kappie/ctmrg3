function find_T_pseudocrit_chi
  % Simulation parameters
  q = 5;
  chi_values = [10 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90];
  % chi_values = [20 30 40 50 60 70 80 90];
  TolX = 1e-6;
  tolerance = 1e-7;
  method = 'entropy';

  sim = FindTCritFixedChi(q, TolX, chi_values);
  sim.method = method;
  sim.tolerance = tolerance;
  sim.T_crit_range = [0.95 1.05];
  sim = sim.run();

  % Fitting parameters
  TolXFit = 1e-12;
  search_width = 6e-2;
  T_crit_guess = 0.96;
  % Fit power law of the form
  % T_pseudocrit(L) = a*L^{-lambda} + T_c
  chi_min = 20;
  chi_max = Inf;
  % a_bounds = [0.01 1000]; a_initial = 1;
  % lambda_bounds = [-1.1 -0.9]; lambda_initial = -0.95;
  % T_crit_bounds = [2.2 2.3]; T_crit_initial = 2.269;
  % lower = [a_bounds(1) lambda_bounds(1) T_crit_bounds(1)];
  % upper = [a_bounds(2) lambda_bounds(2) T_crit_bounds(2)];
  % initial = [a_initial lambda_initial T_crit_initial];
  % lower = [lambda_bounds(1) log(a_bounds(1))];
  % upper = [lambda_bounds(2) log(a_bounds(2))];
  % initial = [lambda_initial log(a_initial)];
  exclude = chi_values < chi_min | chi_values > chi_max;

  % markerplot(chi_values, sim.T_pseudocrits, '--')


  % [T_crit, error, ~] = fit_kosterlitz_transition2(sim.T_pseudocrits, ...
  %   sim.length_scales, exclude, Constants.T_crit_guess(q), search_width, TolXFit)
  % title('kosterlitz')
  [T_crit, slope, mse] = fit_power_law3(sim.length_scales, sim.T_pseudocrits, exclude, search_width, TolXFit);
  title('power law')

  % nu = 1/slope
  T_crit

  % plot(values_to_plot, fit_obj.a.*values_to_plot.^fit_obj.b)
  % hold off
  % set(gca, 'XScale', 'log')
  % set(gca, 'YScale', 'log')
  % xlabel('$(T^{*} - T_c)^{-1/2}$')
  % ylabel('$\log(\epsilon_2 - \epsilon_1)$')
end

function fit_power_law2(length_scales, T_pseudocrits, lower, upper, initial, exclude)
  % Fit power law of the form
  % T_pseudocrit(L) = a*L^{-lambda} + T_c
  model_name = 'power2';
  fit_options = fitoptions(model_name, 'Lower', lower, ...
    'Upper', upper, 'Startpoint', initial, 'Exclude', exclude);
  [fit_obj, goodness] = fit(length_scales', T_pseudocrits', model_name, fit_options)
  plot(fit_obj, length_scales, T_pseudocrits)
end
