function find_T_pseudocrit_chi
  q = 2;
  % q = 2 values energy gap
  % chi_values = [10 12 14 20 30 33 38 43 49 56];
  % q = 2 values entropy
  % chi_values = [10:2:32 33 38 43 49 56];
  % chi_values = [10:1:60];
  chi_values = [120]
  % q = 4 values entropy
  % chi_values = [10:2:34 40 46 53 59 67 75 82 96 105];
  % q = 4 values energy gap
  % chi_values = [10:2:20 25 34 46 59 75 96];
  TolX = 1e-8;
  method = 'entropy';
  tolerance = 1e-8;

  % Parameters for power law fitting
  TolXFit = 1e-12;
  search_width = 1e-3;
  T_crit_guess = 0.95;
  % Fit power law of the form
  % T_pseudocrit(L) = a*L^{-lambda} + T_c
  chi_min = 0;
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

  sim = FindTCritFixedChi(q, TolX, chi_values);
  sim.method = method;
  sim.tolerance = tolerance;
  sim = sim.run();
  % markerplot(chi_values, sim.T_pseudocrits, '--')


  sim.T_pseudocrits
  % sim.length_scales

  % [T_crit, mse, ~] = fit_power_law(sim.length_scales, sim.T_pseudocrits, search_width, TolXFit)
  % fit_power_law2(sim.length_scales, sim.T_pseudocrits, lower, upper, initial, exclude)
  % [T_crit, error] = fit_power_law3(sim.length_scales, sim.T_pseudocrits, ....
  %   exclude, search_width, TolXFit)
  % [T_crit, error, ~] = fit_kosterlitz_transition(sim.T_pseudocrits, ...
  %   sim.length_scales, T_crit_guess, search_width, TolXFit, exclude)
  % [T_crit, error, ~] = fit_kosterlitz_transition2(sim.T_pseudocrits, ...
  %   sim.length_scales, exclude, search_width, TolXFit)
  % title('kosterlitz')
  [T_crit, slope, mse] = fit_power_law3(sim.length_scales, sim.T_pseudocrits, exclude, search_width, TolXFit);
  title('power law')

  nu = 1/slope
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
