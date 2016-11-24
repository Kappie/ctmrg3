function data_collapse_chi_bounding_box
  % loads chi_values and corresponding corr_lengths and t_stars
  chi_values = [2 4 6 8 10 12 14 16 24 32]
  load('t_stars_chi2-32_tol1e-8_TolX1e-7');
  % correlation lengths have a negative sign, because they were acquired from fminbnd
  % and I forgot to make them positive again.
  corr_lengths = -corr_lengths;
  tolerance = 1e-7;
  x_width_left = -2;
  x_width_right = 0.40;
  number_of_points = 10;

  % corr_lengths = find_corresponding_correlation_lengths(chi_values, tolerance)

  % skip first few chi_values
  skipBegin = 0;
  chi_values = chi_values(skipBegin + 1 : end)
  corr_lengths = corr_lengths(skipBegin + 1 : end)

  temperatures = find_corresponding_temperatures(chi_values, corr_lengths, x_width_left, x_width_right, number_of_points);
  order_parameters = find_corresponding_order_params(temperatures, chi_values, tolerance);

  [total_mse, mse_L_values] = data_collapse(chi_values, temperatures, order_parameters, corr_lengths)

  xlabel('$t\xi_{\max}(\chi)$')
  ylabel('$\xi_{\max}(\chi)^{\beta/\nu}m(t, \xi_{\max}(\chi))$')
  make_legend(chi_values, '\chi')
end

function [total_mse, mse_L_values] = data_collapse(chi_values, temperatures, order_parameters, correlation_lengths)
  % input:
  % chi_values: column vector
  % temperatures: array of size (number_of_points, numel(chi_values))
  % order_parameters: array of size (numel(temperatures), numel(chi_values))
  % correlation_lengths: array of size (1, numel(chi_values))

  % Critical exponents
  beta = 1/8; nu = 1;
  MARKERS = markers();

  figure
  hold on
  marker_index = 1;

  x_values = containers.Map('keyType', 'double', 'valueType', 'any');
  scaling_function_values = containers.Map('keyType', 'double', 'valueType', 'any');

  for c = 1:numel(chi_values)
    x_values_chi = zeros(1, numel(temperatures(:, c)));
    scaling_function_values_chi = zeros(1, numel(temperatures(:, c)));

    for t = 1:numel(temperatures(:, c))
      x_values_chi(t) = Constants.reduced_T(temperatures(t, c)) * correlation_lengths(c)^(1/nu);
      scaling_function_values_chi(t) = order_parameters(t, c) * correlation_lengths(c)^(beta/nu);
    end

    x_values(correlation_lengths(c)) = x_values_chi;
    scaling_function_values(correlation_lengths(c)) = scaling_function_values_chi;

    marker = MARKERS(marker_index);
    plot(x_values_chi, scaling_function_values_chi, marker);
    marker_index = marker_index + 1;
  end

  [total_mse, mse_L_values] = mse_data_collapse(x_values, scaling_function_values, correlation_lengths);
  % norm_of_residuals = polyfit_data_collapse(x_values, scaling_function_values, correlation_lengths)
end

function temperatures = find_corresponding_temperatures(chi_values, corr_lengths, x_width_left, x_width_right, number_of_points)
  temperatures = zeros(number_of_points, numel(chi_values));

  for c = 1:numel(chi_values)
    temperatures(:, c) = find_temperatures(corr_lengths(c), x_width_left, x_width_right, number_of_points);
  end
end

function order_params = find_corresponding_order_params(temperatures, chi_values, tolerance)
  order_params = zeros(size(temperatures));
  for c = 1:numel(chi_values)
    % I transpose temperatures(:, c) because I need to pass in a row
    sim = FixedToleranceSimulation(temperatures(:, c)', chi_values(c), tolerance).run();
    order_params(:, c) = sim.compute(OrderParameter);
  end
end

function temperatures = find_temperatures(corr_length, x_width_left, x_width_right, number_of_points)
    reduced_temperatures = linspace(x_width_left, x_width_right, number_of_points) ./ corr_length;
    temperatures = Constants.inverse_reduced_Ts(reduced_temperatures);
end

function corr_lengths = find_corresponding_correlation_lengths(chi_values, tolerance)
  corr_lengths = zeros(1, numel(chi_values));
  temperature = Constants.T_crit;
  sim = FixedToleranceSimulation(temperature, chi_values, tolerance).run();
  corr_lengths = sim.compute(CorrelationLengthAfun);
  % we round the correlation lengths we use to 5 decimal places. Otherwise, due to the varying answer of
  % the Lanczos algorithm, we have to compute observables at slightly different (1e-13)
  % temperatures each time.
  corr_lengths = round(corr_lengths, 5);
end
