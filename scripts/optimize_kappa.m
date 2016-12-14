function optimize_kappa
  chi_values = 80:100;
  number_of_points = 1; width = 0.1;
  x_values = linspace(-width, 0, number_of_points);
  tolerance = 1e-7;

  correlation_lengths_guess = guess_correlation_lengths(chi_values);
  temperatures = find_corresponding_temperatures(x_values, chi_values, correlation_lengths_guess);
  order_params = find_corresponding_order_params(temperatures, chi_values, tolerance);

  [slope, intercept] = optimize_power_law(chi_values, temperatures, order_params)
  plot = true
  data_collapse(chi_values, temperatures, order_params, correlation_lengths_power_law(chi_values, slope, intercept), plot)
end

function [slope, intercept] = optimize_power_law(chi_values, temperatures, order_parameters)
  function norm_of_residuals = mse_collapse(fit_parameters)
    slope = fit_parameters(1);
    intercept = fit_parameters(2);
    correlation_lengths = correlation_lengths_power_law(chi_values, slope, intercept);
    [~, ~, norm_of_residuals] = data_collapse(chi_values, temperatures, order_parameters, correlation_lengths);
  end

  % initial guesses
  slope = 2;
  intercept = -0.077;

  options = optimset('PlotFcns', @optimplotfval, 'TolX', 1e-5);
  fit_parameters = fminsearch(@mse_collapse, [slope, intercept], options)
  slope = fit_parameters(1);
  intercept = fit_parameters(2);
end

function correlation_lengths = guess_correlation_lengths(chi_values)
  % comes from loglog fit to transfer matrix correlation length
  slope = 2;
  intercept = -0.077;
  correlation_lengths = correlation_lengths_power_law(chi_values, slope, intercept);
end

function temperatures = find_corresponding_temperatures(x_values, chi_values, corr_lengths)
  temperatures = containers.Map('keyType', 'double', 'valueType', 'any');
  throw_away_width = 0.1;

  for c = 1:numel(chi_values)
    temperatures_chi = find_temperatures(x_values, corr_lengths(c));
    temperatures_chi = throw_away_if_far_from_Tc(temperatures_chi, throw_away_width);
    temperatures(chi_values(c)) = temperatures_chi;
  end
end

function temperatures = find_temperatures(x_values, corr_length)
  reduced_temperatures = x_values ./ corr_length;
  temperatures = Constants.inverse_reduced_Ts(reduced_temperatures);
end

function correlation_lengths = correlation_lengths_power_law(chi_values, slope, intercept)
  correlation_lengths = 10^intercept .* chi_values .^ slope;
end
