function compare_magnetization_sum
  chi = 16;
  temperature = Constants.T_pseudocrit(chi) ;
  tolerance = 1e-7;


  % [a, b, C, T, Cm, Tm, iterations, convergence, converged] = calculate_environment_tensors_m_at_each_site(temperature, chi, tolerance);
end
