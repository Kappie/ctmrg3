function [total_mse, mse_L_values] = data_collapse(chi_values, temperatures, order_parameters, correlation_lengths)
  % input:
  % chi_values: column vector
  % temperatures: map from chi value to array
  % order_parameters: map from chi value to array
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
    temperatures_chi = temperatures(chi_values(c));
    order_params_chi = order_parameters(chi_values(c));
    x_values_chi = zeros(1, numel(temperatures_chi));
    scaling_function_values_chi = zeros(1, numel(temperatures_chi));

    for t = 1:numel(temperatures_chi)
      x_values_chi(t) = Constants.reduced_T(temperatures_chi(t)) * correlation_lengths(c)^(1/nu);
      scaling_function_values_chi(t) = order_params_chi(t) * correlation_lengths(c)^(beta/nu);
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
