function plot(obj, chi_min, width, T_crit, beta, nu)
  if ~exist('chi_min', 'var')
    chi_min = 0;
  end
  if ~exist('width', 'var')
    width = 10;
  end
  [temperatures, chi_values, scaling_quantities, N_values] = obj.values_to_include(chi_min, width);
  [x_values, scaling_function_values] = obj.collapse(temperatures, N_values, scaling_quantities, ...
    chi_values, T_crit, beta, nu);

  figure
  for c = 1:numel(chi_values)
    hold on
    display(['plotted ' num2str(numel(x_values(:, c))) ' points for chi = ' num2str(chi_values(c))])
    plot(x_values(:, c), scaling_function_values(:, c), 'LineStyle', 'None', 'marker', 'o')
  end
  hold off
end
