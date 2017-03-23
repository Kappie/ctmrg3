function obj = find_best_collapse(obj, chi_min, fit_width, initial, lower_bounds, upper_bounds)
  [temperatures, chi_values, scaling_quantities, N_values] = obj.values_to_include(chi_min, fit_width);
  N_values

  function mse = f_min(inputs)
    T_crit = inputs(1);
    beta = inputs(2);
    nu = inputs(3);

    [x_values, scaling_function_values] = obj.collapse(temperatures, N_values, ...
      scaling_quantities, chi_values, T_crit, beta, nu);
    mse = obj.error_of_collapse(x_values, scaling_function_values, chi_values);
  end

  options = optimset('PlotFcns', @optimplotfval, 'TolX', 1e-9, 'MaxFunEvals', 1500, ...
    'MaxIter', 1500);
  [x, fval, exitflag, output] = fminsearchbnd(@f_min, initial, lower_bounds, upper_bounds, options);
  obj.results = struct('T_crit', x(1), 'beta', x(2), 'nu', x(3), 'mse', fval);
end
