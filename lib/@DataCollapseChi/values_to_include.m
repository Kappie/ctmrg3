function [temperatures, chi_values, scaling_quantities] = values_to_include(obj)
  width = 0.1;
  chi_min = 0;
  include_chi = obj.chi_values >= chi_min;
  include_T = abs(obj.temperatures - Constants.T_crit_guess(obj.q)) < width;

  temperatures = obj.temperatures(include_T)
  chi_values = obj.chi_values(include_chi);
  scaling_quantities = obj.scaling_quantities(include_T, include_chi);
end
