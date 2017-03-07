function [total_mse, mse_L_values] = mse_data_collapse(x_values, y_values, L_values)
  % We assume (up to corrections to scaling) a universal scaling function
  % of the form
  % f(t * L^(1/nu)) = L^(-a) * m(t, L)
  %
  % We assess the data by interpolating the data points corresponding to the largest
  % system size available, and computing the mean squared error.

  % x_values: map from double to array (sorted in ascending order)
  % y_values: map from double to array (corresponding y values)
  % L_values: array of L values. Assumption: L_values is sorted in ascending order.

  mse_L_values = [];

  L_max = L_values(end);
  x_values_L_max = x_values(L_max);
  y_values_L_max = y_values(L_max);
  left_bound = x_values_L_max(1);
  right_bound = x_values_L_max(end);

  for l = 1:numel(L_values(1:end-1))
    % Only use values that fall within the range of the x_values_L_max used for interpolation.
    x = x_values(L_values(l));
    y = y_values(L_values(l));

    indices_within_bounds = x >= left_bound & x <= right_bound;
    x = x(indices_within_bounds);
    y = y(indices_within_bounds);

    mse_L_values(l) = mean_squared_error_from_interpolation(x, y, x_values_L_max, y_values_L_max);
  end

  total_mse = sum(mse_L_values);
end

function mse = mean_squared_error_from_interpolation(x_values_observation, y_values_observation, x_values_estimation, y_values_estimation)
  % no need for extrapolation (and covers the case where both x_values consist of 1 element)
  % if all(size(x_values_observation) == size(x_values_estimation)) && all(x_values_observation == x_values_estimation)
  %   errors = (y_values_observation - y_values_estimation) / y_values_observation;
  %
  % else
  interpolated_y_values = interp1(x_values_estimation, y_values_estimation, x_values_observation, 'pchip');
  % errors = (y_values_observation - interpolated_y_values);
  % why is relative error better?
  errors = (y_values_observation - interpolated_y_values) ./ y_values_observation;
  % end

  mse = mean(errors .^ 2);
end
