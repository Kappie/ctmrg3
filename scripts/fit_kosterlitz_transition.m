function [T_crit, mse, exitflag] = fit_kosterlitz_transition(T_pseudocrits, length_scales, T_crit_guess, search_width, TolX)
  sigma = 0.5;

  function mse = f_minimize(T_crit)
    [fit_object, goodness] = fit((T_pseudocrits' - T_crit).^(-sigma), length_scales', 'exp1')
    plot(fit_object, length_scales, (T_pseudocrits - T_crit))
    mse = goodness.rmse;
    % [slope, intercept, mse] = logfit(length_scales, ...
    %   (T_pseudocrits - T_crit).^(-0.5), 'logy', 'skipBegin', 4, 'skipEnd', 0)
  end

  options = optimset('Display', 'iter', 'TolX', TolX);
  [T_crit, mse, exitflag] = fminsearchbnd(@f_minimize, ...
    T_crit_guess, T_crit_guess - search_width, T_crit_guess + search_width, options)
  [fit_object, goodness] = fit((T_pseudocrits' - T_crit).^(-sigma), length_scales', 'exp1')
  plot(fit_object, length_scales, (T_pseudocrits - T_crit))
end
