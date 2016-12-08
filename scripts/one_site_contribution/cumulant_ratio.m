function ratio = cumulant_ratio(temperature, chi, tolerance, N1, N2)
  [C, T, Cm, Tm] = initial_tensors_converged_environment(temperature, chi, tolerance);
  a = Util.construct_a(temperature);
  b = Util.construct_b(temperature);

  cumulants = [0, 0];

  for i = 1:N2
    [C, T, Cm, Tm, singular_values] = growth_step(chi, a, b, C, T, Cm, Tm);
    if i == N1
      disp('N1')
      cumulants(1) = binder_ratio(a, b, C, T, Cm, Tm, i)
    end
    if i == N2
      disp('N2')
      cumulants(2) = binder_ratio(a, b, C, T, Cm, Tm, i)
    end
  end

  ratio = cumulants(2) / cumulants(1)
end
