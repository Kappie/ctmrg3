function obj = find_best_collapse(obj)
  [temperatures, N_values, scaling_quantities] = obj.values_to_include()

  function mse = f_min(inputs)
    T_crit = inputs(1);
    beta = inputs(2);
    nu = inputs(3);

    [x_values, scaling_function_values] = obj.collapse(temperatures, N_values, ...
      scaling_quantities, T_crit, beta, nu);
    mse = obj.error_of_collapse(x_values, scaling_function_values, N_values);
  end

  options = optimset('PlotFcns', @optimplotfval, 'TolX', 1e-8);
  initial = [obj.initial_T_crit, obj.initial_beta, obj.initial_nu];
  lower_bounds = [2.2 0.1 0.9];
  upper_bounds = [2.3 0.15 1.1];
  [x, fval, exitflag, output] = fminsearchbnd(@f_min, initial, lower_bounds, upper_bounds, options);
  obj.results = struct('T_crit', x(1), 'beta', x(2), 'nu', x(3), 'mse', fval);
end
