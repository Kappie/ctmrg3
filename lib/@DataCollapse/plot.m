function plot(obj, T_crit, beta, nu, temperatures, N_values, scaling_quantities)
  if ~exist('T_crit', 'var')
    T_crit = obj.results.T_crit;
  end
  if ~exist('beta', 'var')
    beta = obj.results.beta;
  end
  if ~exist('nu', 'var')
    nu = obj.results.nu;
  end
  if ~exist('temperatures', 'var')
    temperatures = obj.temperatures;
  end
  if ~exist('N_values', 'var')
    N_values = obj.N_values;
  end
  if ~exist('scaling_quantities', 'var')
    scaling_quantities = obj.scaling_quantities;
  end
  display(['numel temperatures plotted: ' num2str(numel(temperatures))])
  [x_values, scaling_function_values] = obj.collapse(...
    temperatures, ...
    N_values, ...
    scaling_quantities, ...
    T_crit, ...
    beta, ...
    nu);

  figure
  for N_i = 1:numel(N_values)
    hold on
    plot(x_values(:, N_i), scaling_function_values(:, N_i), 'LineStyle', 'None', 'marker', 'o')
  end
  hold off
end
