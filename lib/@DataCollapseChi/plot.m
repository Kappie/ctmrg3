function plot(obj, chi_min, width, T_crit, beta, nu, kappa)
  if ~exist('chi_min', 'var')
    chi_min = 0;
  end
  if ~exist('width', 'var')
    width = 10;
  end
  if ~exist('kappa', 'var')
    kappa = obj.kappa;
  end
  [temperatures, chi_values, scaling_quantities] = obj.values_to_include(chi_min, width);
  N_values = chi_values .^ kappa;
  plot@DataCollapse(obj, T_crit, beta, nu, temperatures, N_values, scaling_quantities);
end
