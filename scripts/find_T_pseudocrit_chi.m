function find_T_pseudocrit_chi
  q = 6;
  % q = 2 values energy gap
  % chi_values = [10 12 14 20 30 33 38 43 49 56];
  % q = 2 values entropy
  % chi_values = [10:2:32 33 38 40 43 49 50 56];
  chi_values = 10:10:80;
  % q = 4 values entropy
  % chi_values = [10:2:34 40 46 53 59 67 75 82 96 105];
  % q = 4 values energy gap
  % chi_values = [10:2:20 25 34 46 59 75 96];
  TolX = 1e-6;
  method = 'entropy';

  % Parameters for power law fitting
  TolXFit = 1e-14;
  search_width = 1e-3;
  % Fit power law of the form
  % T_pseudocrit(L) = a*L^{-lambda} + T_c
  chi_min = 22;
  a_bounds = [0.01 1000]; a_initial = 1;
  lambda_bounds = [-1.1 -0.9]; lambda_initial = -0.95;
  T_crit_bounds = [2.2 2.3]; T_crit_initial = 2.269;
  % lower = [a_bounds(1) lambda_bounds(1) T_crit_bounds(1)];
  % upper = [a_bounds(2) lambda_bounds(2) T_crit_bounds(2)];
  % initial = [a_initial lambda_initial T_crit_initial];
  lower = [lambda_bounds(1) log(a_bounds(1))];
  upper = [lambda_bounds(2) log(a_bounds(2))];
  initial = [lambda_initial log(a_initial)];
  exclude = chi_values < chi_min;

  sim = FindTCritFixedChi(q, TolX, chi_values);
  sim.method = method;
  sim = sim.run();
  sim.T_pseudocrits
  sim.length_scales


  % [T_crit, mse, ~] = fit_power_law(sim.length_scales, sim.T_pseudocrits, search_width, TolXFit)
  % fit_power_law2(sim.length_scales, sim.T_pseudocrits, lower, upper, initial, exclude)
  [T_crit, error] = fit_power_law3(sim.length_scales, sim.T_pseudocrits, ....
    lower, upper, initial, exclude, search_width, TolXFit)

  % title(['Ising model. $T^{*}$ by maximum entropy. $T_c = ' num2str(T_crit, 6) '$.'])
  % ylabel('$\log(T^{*}(\chi) - T_c)$')
  % % xlabel('$\log(\xi(\chi))$')
  % % xlabel('$\log(-\log(S(\chi, T^{*})))$')
  % xlabel('$1 / \log(C_1/C_2)$')

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

function fit_power_law2(length_scales, T_pseudocrits, lower, upper, initial, exclude)
  % Fit power law of the form
  % T_pseudocrit(L) = a*L^{-lambda} + T_c
  model_name = 'power2';
  fit_options = fitoptions(model_name, 'Lower', lower, ...
    'Upper', upper, 'Startpoint', initial, 'Exclude', exclude);
  [fit_obj, goodness] = fit(length_scales', T_pseudocrits', model_name, fit_options)
  plot(fit_obj, length_scales, T_pseudocrits)
end

function [T_crit, error_of_fit] = fit_power_law3(length_scales, T_pseudocrits, lower, upper, initial, exclude, search_width, TolX)
  % Find T_crit that best fits linear relation
  % log(T_pseudocrits - T_crit) = log(a) - lambda*log(length_scales)
  minimize_options = optimset('Display', 'iter', 'TolX', TolX);
  T_crit_guess = T_pseudocrits(end);
  ORDER_LINEAR_FUNCTION = 1;

  length_scales_to_fit = length_scales(~exclude);
  T_pseudocrits_to_fit = T_pseudocrits(~exclude);

  function error_of_fit = f_minimize(T_crit)
    y = log(T_pseudocrits_to_fit - T_crit);
    x = log(length_scales_to_fit);
    [p, S] = polyfit(x, y, ORDER_LINEAR_FUNCTION);
    error_of_fit = S.normr;
  end

  % [T_crit, error_of_fit, exitflag] = fminbnd(@f_minimize, ...
  %   T_crit_guess - search_width, T_crit_guess, minimize_options);
  [T_crit, error_of_fit, exitflag] = fminsearchbnd(@f_minimize, ...
    T_crit_guess, T_crit_guess - search_width, T_crit_guess, minimize_options);
  [p] = polyfit(log(length_scales), log(T_pseudocrits - T_crit), ORDER_LINEAR_FUNCTION)
  slope = p(1); intercept = p(2);

  x = linspace(log(length_scales(1)), log(length_scales(end)));
  y = polyval(p, x);
  figure
  hold on
  markerplot(log(length_scales(exclude)), log(T_pseudocrits(exclude) - T_crit), 'None')
  markerplot(log(length_scales_to_fit), log(T_pseudocrits_to_fit - T_crit), 'None')
  plot(x, y, 'Color', 'black')
  hold off

end
