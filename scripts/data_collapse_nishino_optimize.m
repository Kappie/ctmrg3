function data_collapse_nishino_optimize
  q = 2;
  temperature = Constants.T_crit_guess(q);
  % N_values = 500:100:3500;
  N_values = [10:10:90 100:100:1000 1250:250:2750];
  % chi_values = 14:2:40;
  % chi_values = [24, 28, 33, 38, 43, 49, 56, 64];
  chi_values = [4, 8, 12, 16, 20];
  % chi_values = [4, 6]
  % chi_values = 4:2:14;
  tolerance = 1e-8;
  initial_condition_corr_length = 'spin-up';

  initial = 0.125;
  lower_bounds = 0.1;
  upper_bounds = 0.2;

  sim = FixedNSimulation(temperature, chi_values, N_values, q).run();

  order_params = sim.compute('order_parameter');
  length_scales_chi = get_length_scales_chi(temperature, chi_values, tolerance, q, initial_condition_corr_length);

  find_best_beta(order_params, length_scales_chi, N_values, initial, lower_bounds, upper_bounds);
  make_legend(chi_values, '\chi')
end

function find_best_beta(order_params, length_scales_chi, N_values, initial, lower_bounds, upper_bounds)
  x_values = containers.Map('keyType', 'double', 'valueType', 'any');
  % for N = N_values
  %   x_values(N) = length_scales_chi ./ N;
  % end
  for c = 1:numel(length_scales_chi)
    % flip array because smallest x value should come first
    x_values(length_scales_chi(c)) = fliplr(length_scales_chi(c) ./ N_values);
  end

  function error_of_collapse = f_minimize(beta)
    y_values = get_y_values(order_params, length_scales_chi, N_values, beta);
    error_of_collapse = mse_data_collapse_all_sets(x_values, y_values, length_scales_chi);
  end

  options = optimset('PlotFcns', @optimplotfval, 'TolX', 1e-12);
  [best_beta, fval, exitflag, output] = fminsearchbnd(@f_minimize, initial, lower_bounds, upper_bounds, options)
  % [best_beta, fval, exitflag, output] = fminbnd(@f_minimize, lower_bounds, upper_bounds, options)

  y_values_best_fit = get_y_values(order_params, length_scales_chi, N_values, best_beta);
  y_values_exact = get_y_values(order_params, length_scales_chi, N_values, 0.125)
  % plot_collapse(x_values, y_values_best_fit, length_scales_chi)
  plot_collapse(x_values, y_values_exact, length_scales_chi)



end

function y_values = get_y_values(order_params, length_scales_chi, N_values, beta)
  y_values = containers.Map('keyType', 'double', 'valueType', 'any');
  for c = 1:numel(length_scales_chi)
    % y_values(length_scales_chi(c)) = fliplr(order_params(c, :) .* length_scales_chi(c).^beta);
    y_values(length_scales_chi(c)) = fliplr(order_params(c, :) .* N_values.^beta);

  end
  % for n = 1:numel(N_values)
  %   N = N_values(n);
  %   y_values(N) = order_params(:, n)' .* N.^beta;
  % end
end

function plot_collapse(x_values, y_values, length_scales_chi)
  x_domain = [0, 2];
  y_domain = [0, 1.2];
  figure
  hold on
  for length_scale = length_scales_chi
    x_vals = x_values(length_scale);
    y_vals = y_values(length_scale);
    x_indices = x_vals >= x_domain(1) & x_vals <= x_domain(2);
    y_indices = y_vals >= y_domain(1) & y_vals <= y_domain(2);
    indices_to_use = x_indices & y_indices;
    markerplot(x_vals(indices_to_use), y_vals(indices_to_use), 'None')
  end
  hold off
  % make_legend(chi_values, '$\chi')
end

function length_scales = get_length_scales_chi(temperature, chi_values, tolerance, q, initial_condition)
  sim = FixedToleranceSimulation(temperature, chi_values, tolerance, q);
  sim.initial_condition = initial_condition;
  sim = sim.run();
  % length_scales = 10.^(12.*sim.compute('entropy'))
  length_scales = round(sim.compute('correlation_length'), 8);
end
