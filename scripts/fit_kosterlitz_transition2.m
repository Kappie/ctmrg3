function [T_crit, error_of_fit, exitflag] = fit_kosterlitz_transition2(T_pseudocrits, length_scales, exclude, search_width, TolX)
  minimize_options = optimset('Display', 'iter', 'TolX', TolX);
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
  [p] = polyfit(reduced_temperatures(~exclude), log(length_scales_to_fit), ORDER_LINEAR_FUNCTION)
  slope = p(1); intercept = p(2);

  x = linspace(reduced_temperatures(end), reduced_temperatures(1))
  y = polyval(p, x);
  figure
  hold on
  markerplot(reduced_temperatures, log(length_scales), '--')
  plot(x, y, 'Color', 'black')
  hold off
end
