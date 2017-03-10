function obj = find_best_collapse(obj)
  width = 0.05;
  include_N = obj.N_values > 160;
  include_T = abs(obj.temperatures - Constants.T_crit) < width;

  function mse = f_min(inputs)
    T_crit = inputs(1);
    beta = inputs(2);
    nu = inputs(3);

    [x_values, scaling_function_values, N_values] = obj.collapse(T_crit, beta, nu, include_T, include_N);
    mse = obj.error_of_collapse(x_values, scaling_function_values, N_values);
  end

  options = optimset('PlotFcns', @optimplotfval, 'TolX', 1e-8);
  initial = [obj.initial_T_crit, obj.initial_beta, obj.initial_nu];
  lower_bounds = [2.2 0.1 0.9];
  upper_bounds = [2.3 0.15 1.1];
  [x, fval, exitflag, output] = fminsearchbnd(@f_min, initial, lower_bounds, upper_bounds, options);
  obj.results = struct('T_crit', x(1), 'beta', x(2), 'nu', x(3), 'mse', fval);
end
