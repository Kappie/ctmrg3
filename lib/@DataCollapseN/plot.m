function plot(obj, N_min, width, T_crit, beta, nu)
  if ~exist('N_min', 'var')
    N_min = 0;
  end
  if ~exist('width', 'var')
    width = 10;
  end
  [temperatures, N_values, scaling_quantities] = obj.values_to_include(N_min, width);
  plot@DataCollapse(obj, T_crit, beta, nu, temperatures, N_values, scaling_quantities);
end
