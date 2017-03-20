function [temperatures, N_values, scaling_quantities] = values_to_include(obj, N_min, width)
  include_N = obj.N_values >= N_min;
  include_T = abs(obj.temperatures - Constants.T_crit_guess(obj.q)) < width;

  temperatures = obj.temperatures(include_T);
  N_values = obj.N_values(include_N);
  display(['number of temperatures used to fit: ' num2str(numel(temperatures))])
  display(['number of N values used to fit: ' num2str(numel(N_values))])
  scaling_quantities = obj.scaling_quantities(include_T, include_N);
end
