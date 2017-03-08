function mse = error_of_collapse_old(obj, x_values, scaling_function_values)
  x_values_map = containers.Map('keyType', 'double', 'valueType', 'any');
  scaling_function_values_map = containers.Map('keyType', 'double', 'valueType', 'any');
  for n = 1:numel(obj.N_values)
    x_values_map(obj.N_values(n)) = x_values(:, n);
    scaling_function_values_map(obj.N_values(n)) = scaling_function_values(:, n);
  end

  [mse, ~] = mse_data_collapse(x_values_map, scaling_function_values_map, obj.N_values);
end

function error = error_of_collapse_old(obj, x_values, scaling_function_values)
  order = 5;
  [polynomial, error_struct, mu] = polyfit(x_values(:), scaling_function_values(:), order);
  norm_of_residuals = error_struct.normr;
  error = norm_of_residuals;
end
