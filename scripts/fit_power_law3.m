function [T_crit, error_of_fit] = fit_power_law3(length_scales, T_pseudocrits, exclude, search_width, TolX)
  % Find T_crit that best fits linear relation
  % log(T_pseudocrits - T_crit) = log(a) - lambda*log(length_scales)
  % minimize_options = optimset('Display', 'iter', 'TolX', TolX);
  minimize_options = optimset('TolX', TolX, 'TolFun', TolX);
  T_crit_guess = T_pseudocrits(end);
  ORDER_LINEAR_FUNCTION = 1;

  length_scales_to_fit = length_scales(~exclude);
  T_pseudocrits_to_fit = T_pseudocrits(~exclude);

  function error_of_fit = f_minimize(T_crit)
    x = log(length_scales_to_fit);
    y = log(T_pseudocrits_to_fit - T_crit);
    [p, S] = polyfit(x, y, ORDER_LINEAR_FUNCTION);
    error_of_fit = S.normr;
  end

  % [T_crit, error_of_fit, exitflag] = fminbnd(@f_minimize, ...
  %   T_crit_guess - search_width, T_crit_guess, minimize_options);
  [T_crit, error_of_fit, exitflag] = fminsearchbnd(@f_minimize, ...
    T_crit_guess, T_crit_guess - search_width, T_crit_guess, minimize_options);
  [p, S] = polyfit(log(length_scales_to_fit), log(T_pseudocrits_to_fit - T_crit), ORDER_LINEAR_FUNCTION);
  slope = p(1); intercept = p(2);

  length_scales_to_plot = linspace(length_scales(1), length_scales(end));
  T_pseudocrits_best_fit = T_crit + exp(intercept)*length_scales_to_plot.^slope;
  % T_pseudocrits_best_fit = exp(polyval(p, length_scales_to_plot)) + T_crit;
  figure
  hold on
  % markerplot(log(length_scales(exclude)), log(T_pseudocrits(exclude) - T_crit), 'None')
  % markerplot(log(length_scales_to_fit), log(T_pseudocrits_to_fit - T_crit), 'None')
  markerplot(length_scales, T_pseudocrits, '--')
  plot(length_scales_to_plot, T_pseudocrits_best_fit, 'Color', 'black')
  hold off
  title(['Power law fit. $T_c = ' num2str(T_crit) '$.'])

end
