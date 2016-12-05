function compare_magnetization_sum
  temperature = Constants.T_crit - 0.001;
  chi = 4;
  tolerance = 1e-15;

  m_sum = magnetization_sum(temperature, chi, tolerance);

end
