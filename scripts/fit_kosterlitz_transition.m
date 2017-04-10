function [T_crit, mse, exitflag] = fit_kosterlitz_transition(T_pseudocrits, length_scales, T_crit_guess, search_width, TolX, exclude)
  sigma = 0.5;
  % lower = [0 0];
  % upper = [Inf Inf];
  % initial = [1 1];

  function mse = f_minimize(T_crit)
    model_name = 'exp1';
    fit_options = fitoptions(model_name, 'Lower', lower, ...
      'Upper', upper, 'Startpoint', initial, 'Exclude', exclude);
    [fit_object, goodness] = fit((T_pseudocrits' - T_crit).^(-sigma), length_scales', model_name, ...
      fit_options);
    plot(fit_object, length_scales, (T_pseudocrits - T_crit).^(-sigma))
    mse = goodness.rmse;
    % [slope, intercept, mse] = logfit(length_scales, ...
    %   (T_pseudocrits - T_crit).^(-0.5), 'logy', 'skipBegin', 4, 'skipEnd', 0)
  end

  options = optimset('Display', 'iter', 'TolX', TolX);
  [T_crit, mse, exitflag] = fminsearchbnd(@f_minimize, ...
    T_crit_guess, T_crit_guess - search_width, T_crit_guess + search_width, options)
  [fit_object, goodness] = fit((T_pseudocrits' - T_crit).^(-sigma), length_scales', 'exp1')
  plot(fit_object, length_scales, (T_pseudocrits - T_crit).^(-sigma))
end
