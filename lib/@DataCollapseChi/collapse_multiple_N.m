function [x_values, scaling_function_values] = collapse_multiple_N(obj, temperatures, N_values, scaling_quantities, chi_values, T_crit, beta, nu)
  % Here, N_values is a (numel(temperatures), numel(chi_values)) array that gives a length scale
  % for each combination of temperature and chi.
  ts = (temperatures - T_crit) / T_crit;
  x_values = zeros(numel(temperatures), numel(chi_values));
  scaling_function_values = zeros(numel(temperatures), numel(chi_values));
  for t_i = 1:numel(ts)
    for chi_i = 1:numel(chi_values)
      x_values(t_i, chi_i) = ts(t_i) * N_values(t_i, chi_i)^(1/nu);
      scaling_function_values(t_i, chi_i) = N_values(t_i, chi_i)^(beta/nu)*scaling_quantities(t_i, chi_i);
    end
  end
end
