function mse = mean_squared_error_from_interpolation(x_obs, y_obs, x_query, y_query)
  y_interpolated = interp1(x_obs, y_obs, x_query, 'pchip');
  errors = (y_query - y_interpolated);
  mse = mean(abs(errors));
  % interpolated_y_values = interp1(x_values_estimation, y_values_estimation, x_values_observation, 'pchip');
  % errors = (y_values_observation - interpolated_y_values);
  % mse = mean(errors .^ 2);
end
