function [x_values, scaling_function_values] = collapse(obj, temperatures, N_values, scaling_quantities, T_crit, beta, nu)
  ts = (temperatures - T_crit) / T_crit;
  x_values = zeros(numel(temperatures), numel(N_values));
  scaling_function_values = zeros(numel(temperatures), numel(N_values));
  for t_i = 1:numel(ts)
    for N_i = 1:numel(N_values)
      x_values(t_i, N_i) = ts(t_i) * N_values(N_i)^(1/nu);
      scaling_function_values(t_i, N_i) = N_values(N_i)^(beta/nu)*scaling_quantities(t_i, N_i);
    end
  end
end
