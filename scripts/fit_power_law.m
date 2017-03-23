function [T_crit, mse, exitflag] = fit_power_law(length_scales, T_pseudocrits, search_width, TolX)
  T_crit_guess = T_pseudocrits(end);

  function mse = f_minimize(T_crit)
    t_pseudocrits = abs(T_pseudocrits - T_crit);
    [slope, intercept, mse] = logfit(1./length_scales, t_pseudocrits, ...
      'loglog', 'skipBegin', 4, 'skipEnd', 0);
  end

  options = optimset('Display', 'iter', 'TolX', TolX);
  [T_crit, mse, exitflag] = fminbnd(@f_minimize, ...
    T_crit_guess - search_width, T_crit_guess, options);
end
