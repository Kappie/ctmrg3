function data_collapse_free_energy
  x_values = [-0.05 -0.1 -1];
  chi_values = 10:2:26;
  tolerance = 1e-7;

  free_energies = zeros(numel(x_values), numel(chi_values));
  order_params = zeros(numel(x_values), numel(chi_values));
  ctm_length_scales = zeros(1, numel(chi_values));
  correlation_lengths = zeros(1, numel(chi_values));
  for c = 1:numel(chi_values)
    correlation_lengths(c) = calculate_correlation_length(Constants.T_crit, chi_values(c), tolerance);
    ctm_length_scales(c) = ctm_length_scale(Constants.T_crit, chi_values(c), tolerance);
    for x_index = 1:numel(x_values)
      reduced_T = x_values(x_index) / correlation_lengths(c);
      % reduced_T = x_values(x_index) / ctm_length_scales(c);
      sim = FixedToleranceSimulation(Constants.inverse_reduced_Ts(reduced_T), chi_values(c), tolerance).run();
      free_energies(x_index, c) = sim.compute(FreeEnergy);
      order_params(x_index, c) = sim.compute(OrderParameter);
    end
  end


  % diffs = free_energies - Constants.free_energy_per_site(temperatures);

  beta = 1/8; nu = 1;
  rho = 2;
  % scaling_function_values = diffs .* ctm_length_scales.^(rho/nu);
  scaling_function_values = order_params .* correlation_lengths .^ (beta/nu);
  % scaling_function_values = order_params .* ctm_length_scales .^ (beta/nu);
  max(scaling_function_values, [], 2)
  scaling_function_values = scaling_function_values - max(scaling_function_values, [], 2)
  % throw away smallest 10 chi values
  % throw_away = 8
  % scaling_function_values = scaling_function_values(:, throw_away:end)
  % chi_values = chi_values(throw_away:end)

  markerplot(chi_values, scaling_function_values, '--')
  make_legend(x_values, 'x')
  % yyaxis left
  % markerplot(chi_values, order_params, '--', 'loglog')
  xlabel('$\chi$')
  % ylabel('$m(t = 0, \chi)$')
  % yyaxis right
  % markerplot(chi_values, ctm_length_scales, '--', 'loglog')
  % ylabel('$N_{\mathrm{CTM}}$')
  % ctm_length_scales
  % [slope, intercept] = logfit(ctm_length_scales, correlation_lengths, 'loglog', 'skipBegin', 20)

  % ylabel('$m(t = 0, \chi)\xi(\chi)^{\beta/\nu}$')
  % ylabel('$\Delta m(t = 0, \chi)N_{\mathrm{CTM}}(\chi)^{\beta/\nu}$')
  ylabel('$\phi(\chi) - \max_{\chi}\phi(\chi)$')
  title(['Convergence of scaling function $\phi_m(x)$ at $x \equiv tN_{\mathrm{CTM}}(\chi)$'])
  % scaling_function_values = order_params .* correlation_lengths.^(beta/nu);
  % markerplot(chi_values, diffs, '--', 'loglog');
  % markerplot(correlation_lengths, diffs, '--', 'loglog')
  % [slope, intercept, mse] = logfit(correlation_lengths, diffs, 'loglog', 'skipBegin', 2)

end
