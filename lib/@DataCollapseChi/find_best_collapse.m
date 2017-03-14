function obj = find_best_collapse(obj)
  [temperatures, chi_values, scaling_quantities] = obj.values_to_include()

  function mse = f_min(inputs)
    T_crit = inputs(1);
    beta = inputs(2);
    nu = inputs(3);
    kappa = inputs(4);

    N_values = round(chi_values .^ kappa, 5);

    [x_values, scaling_function_values] = obj.collapse(temperatures, N_values, ...
      scaling_quantities, T_crit, beta, nu);
    mse = obj.error_of_collapse(x_values, scaling_function_values, N_values);
  end

  options = optimset('PlotFcns', @optimplotfval, 'TolX', 1e-8);
  initial = [obj.initial_T_crit, obj.initial_beta, obj.initial_nu, obj.initial_kappa];
  lower_bounds = [2.269 0.11 0.997 1.85];
  upper_bounds = [2.270 0.14 1.006 2.05];
  [x, fval, exitflag, output] = fminsearchbnd(@f_min, initial, lower_bounds, upper_bounds, options);
  obj.results = struct('T_crit', x(1), 'beta', x(2), 'nu', x(3), 'kappa', x(4), 'mse', fval);
  % obj.N_values = obj.chi_values .^ obj.results.kappa;
  obj.N_values = obj.correlation_lengths();
end
