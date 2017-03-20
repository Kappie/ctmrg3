function obj = find_best_collapse(obj, N_min, fit_width, initial, lower_bounds, upper_bounds)
  [temperatures, N_values, scaling_quantities] = obj.values_to_include(N_min, fit_width);

  function mse = f_min(inputs)
    T_crit = inputs(1);
    beta = inputs(2);
    nu = inputs(3);

    [x_values, scaling_function_values] = obj.collapse(temperatures, N_values, ...
      scaling_quantities, T_crit, beta, nu);
    mse = obj.error_of_collapse(x_values, scaling_function_values, N_values);
  end

  % options = optimset('PlotFcns', @optimplotfval, 'TolX', 1e-12);
  options = optimset('TolX', 1e-12);
  [x, fval, exitflag, output] = fminsearchbnd(@f_min, initial, lower_bounds, upper_bounds, options);
  obj.results = struct('T_crit', x(1), 'beta', x(2), 'nu', x(3), 'mse', fval);
end
