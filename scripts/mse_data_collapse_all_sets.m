function [total_mse] = mse_data_collapse_all_sets(x_values, y_values, L_values)
  % We assume (up to corrections to scaling) a universal scaling function
  % of the form
  % f(t * L^(1/nu)) = L^(-a) * m(t, L)
  %
  % We assess the fitness of the data collapse by interpolating the data points of one set, and calculating the mean
  % squared error (mse) with the points of the other data sets in the overlapping region.
  % We repeat this for all sets. (See Bhattacharjee 2001)

  % x_values: map from double to array (sorted in ascending order)
  % y_values: map from double to array (corresponding y values)
  % L_values: array of L values. Assumption: L_values is sorted in ascending order.

  % Example of a map:
  % x_values = containers.Map('keyType', 'double', 'valueType', 'any');
  % % x_values beloning to length scale of 100
  % x_values(100) = -10:1:10;

  total_mse = 0;

  for L = L_values
    for L_prime = L_values(L_values ~= L)
      total_mse = total_mse + ...
        mse_in_overlapping_region(x_values(L), y_values(L), x_values(L_prime), y_values(L_prime));
    end
  end
end

function [mse] = mse_in_overlapping_region(x_obs, y_obs, x_query, y_query)
  left_bound = x_obs(1);
  right_bound = x_obs(end);
  indices_within_bounds = x_query >= left_bound & x_query <= right_bound;
  % If a set has no data points that fall within two data points of the other set,
  % they cannot be compared and we return a mean squared error of infinity.
  % (This should never happen if the values of the exponents and T_crit are anywhere
  % near the actual values.)
  if all(indices_within_bounds == false)
    mse = Inf;
    return
  end
  x_query = x_query(indices_within_bounds);
  y_query = y_query(indices_within_bounds);
  mse = mean_squared_error_from_interpolation(x_obs, y_obs, x_query, y_query);
end
