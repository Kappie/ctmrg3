function [x_values, scaling_function_values, N_values] = collapse(obj, T_crit, beta, nu, include_T, include_N)
  if ~exist('include_T', 'var')
    include_T = true(1, numel(obj.temperatures));
  end
  if ~exist('include_N', 'var')
    include_N = true(1, numel(obj.N_values));
  end

  temperatures = obj.temperatures(include_T);
  N_values = obj.N_values(include_N);
  scaling_quantities = obj.scaling_quantities(include_T, include_N);

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
