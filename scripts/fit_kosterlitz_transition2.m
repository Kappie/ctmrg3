function [T_crit, error_of_fit, exitflag] = fit_kosterlitz_transition2(T_pseudocrits, length_scales, exclude, search_width, TolX)
  % minimize_options = optimset('Display', 'iter', 'TolX', TolX, 'TolFun', TolX);
  minimize_options = optimset('TolX', TolX, 'TolFun', TolX);
  T_crit_guess = T_pseudocrits(end);
  ORDER_LINEAR_FUNCTION = 1;
  sigma = 1/2;

  length_scales_to_fit = length_scales(~exclude);
  T_pseudocrits_to_fit = T_pseudocrits(~exclude);

  function error_of_fit = f_minimize(T_crit)
    x = (T_pseudocrits_to_fit - T_crit).^(-sigma);
    y = log(length_scales_to_fit);
    [p, S] = polyfit(x, y, ORDER_LINEAR_FUNCTION);
    error_of_fit = S.normr;
  end

  [T_crit, error_of_fit, exitflag] = fminsearchbnd(@f_minimize, ...
    T_crit_guess, T_crit_guess - search_width, T_crit_guess, minimize_options);

  reduced_temperatures = (T_pseudocrits - T_crit).^(-sigma);
  [p, S] = polyfit(reduced_temperatures(~exclude), log(length_scales_to_fit), ORDER_LINEAR_FUNCTION);
  slope = p(1); intercept = p(2);

  % temperatures_to_plot = linspace(reduced_temperatures(1), reduced_temperatures(end));
  temperatures_to_plot = linspace(T_pseudocrits(1), T_pseudocrits(end));
  reduced_temperatures_to_plot = (temperatures_to_plot - T_crit).^(-sigma);
  length_scales_best_fit = exp(polyval(p, reduced_temperatures_to_plot));
  figure
  hold on
  % markerplot(T_pseudocrits, exp(intercept)*exp(slope.*reduced_temperatures), 'None')
  markerplot(T_pseudocrits, length_scales, '--')
  plot(temperatures_to_plot, length_scales_best_fit)
  % markerplot(T_pseudocrits, length_scales, )
  % markerplot(exp(intercept)*exp(slope.*reduced_temperatures), length_scales, 'None')
  % plot(exp(intercept)*exp(slope*temperatures_to_plot), length_scales_best_fit, 'Color', 'black')
  hold off
end
