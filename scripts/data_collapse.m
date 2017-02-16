function [total_mse, mse_L_values, norm_of_residuals] = data_collapse(chi_values, temperatures, quantities, correlation_lengths, scaling_exponent, plot_result)
  % input:
  % chi_values: column vector
  % temperatures: map from chi value to array
  % quantities: map from chi value to array
  % correlation_lengths: array of size (1, numel(chi_values))

  if ~exist('plot_result', 'var')
    plot_result = false;
  end

  % Set nu to one for simplicity.
  nu = 1;
  MARKERS = markers();

  if plot_result
    figure
    hold on
    marker_index = 1;
  end

  x_values = containers.Map('keyType', 'double', 'valueType', 'any');
  scaling_function_values = containers.Map('keyType', 'double', 'valueType', 'any');

  for c = 1:numel(chi_values)
    temperatures_chi = temperatures(chi_values(c));
    order_params_chi = quantities(chi_values(c));
    x_values_chi = zeros(1, numel(temperatures_chi));
    scaling_function_values_chi = zeros(1, numel(temperatures_chi));

    for t = 1:numel(temperatures_chi)
      x_values_chi(t) = Constants.reduced_T(temperatures_chi(t)) * correlation_lengths(c)^(1/nu);
      scaling_function_values_chi(t) = order_params_chi(t) * correlation_lengths(c)^(scaling_exponent/nu);
    end

    x_values(correlation_lengths(c)) = x_values_chi;
    scaling_function_values(correlation_lengths(c)) = scaling_function_values_chi;

    if plot_result
      marker = MARKERS(marker_index);
      plot(x_values_chi, scaling_function_values_chi, marker);
      marker_index = mod(marker_index, numel(MARKERS)) + 1;
    end
  end

  [total_mse, mse_L_values] = mse_data_collapse(x_values, scaling_function_values, correlation_lengths);
  norm_of_residuals = polyfit_data_collapse(x_values, scaling_function_values, correlation_lengths);
end
