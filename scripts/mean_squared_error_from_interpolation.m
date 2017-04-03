function mse = mean_squared_error_from_interpolation(x_obs, y_obs, x_query, y_query)
  y_interpolated = interp1(x_obs, y_obs, x_query, 'pchip');
  errors = (y_query - y_interpolated);
  mse = mean(abs(errors));
end
