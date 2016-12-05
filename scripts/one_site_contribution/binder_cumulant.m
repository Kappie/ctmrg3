function b = binder_cumulant(temperature, chi, tolerance)
  [a, b, C, T, Cm, Tm, iterations, convergence, converged] = calculate_environment_tensors_m_at_each_site(temperature, chi, tolerance);

  % b = magnetization(a, b, C, T, Cm, Tm)^2 / magnetization_squared(a, b, C, T, Cm, Tm);
  m_sum = magnetization(a, b, C, T, Cm, Tm) / (2 * iterations + 1)^2
  m_per_site = Magnetization.value_at(temperature, C, T);
  % m2 = magnetization_squared(a, b, C, T, Cm, Tm) / (2 * iterations + 1)^2
  b = 100; % meh

  disp(['did ' num2str(iterations) ' iterations!!'])
end
