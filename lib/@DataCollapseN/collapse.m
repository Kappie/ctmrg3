function [x_values, scaling_function_values] = collapse(obj, T_crit, beta, nu)
  ts = (obj.temperatures - T_crit) / T_crit;
  x_values = zeros(numel(obj.temperatures), numel(obj.N_values));
  scaling_function_values = zeros(numel(obj.temperatures), numel(obj.N_values));
  for t_i = 1:numel(ts)
    for N_i = 1:numel(obj.N_values)
      x_values(t_i, N_i) = ts(t_i) * obj.N_values(N_i)^(1/nu);
      scaling_function_values(t_i, N_i) = obj.N_values(N_i)^(beta/nu)*obj.scaling_quantities(t_i, N_i);
    end
  end
end
