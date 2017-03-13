function [temperatures, N_values, scaling_quantities] = values_to_include(obj)
  width = 1;
  N_min = 0;
  include_N = obj.N_values > 0;
  include_T = abs(obj.temperatures - Constants.T_crit) < width;

  temperatures = obj.temperatures(include_T)
  N_values = obj.N_values(include_N);
  scaling_quantities = obj.scaling_quantities(include_T, include_N);
end
