function plot_binder_ratio
  chi = 32;
  temperature = Constants.T_pseudocrit(chi);
  % temperature = Constants.T_crit;
  tolerance = 1e-7;

  profile on
  [a, b, C, T, Cm, Tm, iterations, convergence, converged] = calculate_environment_tensors_m_at_each_site(temperature, chi, tolerance);
  profile viewer

end
