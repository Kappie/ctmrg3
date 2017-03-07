function error = error_of_collapse(obj, x_values, scaling_function_values)
  plot(x_values(:), scaling_function_values(:), 'marker', 'o', 'LineStyle', 'none')
end

function mse = error_of_collapse_old(obj, x_values, scaling_function_values)
  x_values_map = containers.Map('keyType', 'double', 'valueType', 'any');
  scaling_function_values_map = containers.Map('keyType', 'double', 'valueType', 'any');
  for n = 1:numel(obj.N_values)
    x_values_map(obj.N_values(n)) = x_values(:, n);
    scaling_function_values_map(obj.N_values(n)) = scaling_function_values(:, n);
  end

  [mse, ~] = mse_data_collapse(x_values_map, scaling_function_values_map, obj.N_values);
end
