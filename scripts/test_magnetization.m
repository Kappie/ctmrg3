function test_magnetization
  width = 0.1; number_of_points = 9;
  % temperatures = linspace(Constants.T_crit - width, Constants.T_crit + width, number_of_points)
  temperatures = [Constants.T_crit];
  chi_values = [4];
  tolerance = 1e-7;

  magnetizations = zeros(numel(temperatures), numel(chi_values), 2);

  for t = 1:numel(temperatures)
    for c = 1:numel(chi_values)
      disp(['doing chi = ' num2str(chi_values(c)) ', temp = ' num2str(temperatures(t)) '.'])

      [a, b, C, T, Cm, Tm, iterations, convergence, converged] = ...
        calculate_environment_tensors_m_at_each_site(temperatures(t), chi_values(c), tolerance);

      % disp(['did ' num2str(iterations) ' iterations.'])
      %
      % magnetizations(t, c, 1) = magnetization(a, b, C, T, Cm, Tm) / (2 * iterations + 1)^2;
      % magnetizations(t, c, 2) = contract_peps(C, C, C, C, T, T, T, T, b) / ...
      %   contract_peps(C, C, C, C, T, T, T, T, a);
    end
  end

  % markerplot(temperatures, squeeze(magnetizations), '--')
  % legend({'$N^{-1}\sum_i \langle \sigma_i \rangle$', '$\langle \sigma_0 \rangle$'})
end
