function plot_order_param_and_correlation_length
  width = +0.0000;
  temperature = Constants.T_crit + width;
  chi_values = 6:1:60;
  % chi_values = 6:1:22;
  tolerance = 1e-7;
  initial_condition = 'spin-up';

  sim = FixedToleranceSimulation(temperature, chi_values, tolerance);
  sim.initial_condition = initial_condition;
  sim = sim.run();
  order_params = sim.compute(OrderParameter);
  % free_energies = sim.compute(FreeEnergy);
  diffs_order_params = order_params - Constants.order_parameter(temperature);
  % diffs_free_energies = abs(free_energies - Constants.free_energy_per_site(temperature));
  corr_lengths = sim.compute(CorrelationLengthAfun);
  % free_energies = sim.compute(FreeEnergies);

  figure
  % markerplot(chi_values, [diffs_order_params; corr_lengths], '--', 'semilogy')
  yyaxis left
  % markerplot(chi_values, [diffs_order_params' diffs_free_energies'], '--', 'semilogy')
  markerplot(chi_values, diffs_order_params, '--', 'semilogy')
  ylabel('$m - m_{\mathrm{exact}}$');
  % legend({'error order parameter', 'error free energy'}, 'Location', 'best')

  yyaxis right
  markerplot(chi_values, corr_lengths, '--')
  ylabel('$\xi$')

  xlabel('$\chi$')
  title(['$T = T_c + ' num2str(width) '$'])
  % title('$T = T_c - 0.1$')
  % right_y_axis = findall(0, 'YAxisLocation', 'right');
  % left_y_axis = findall(0, 'YAxisLocation', 'left');
  % set(left_y_axis, 'Yscale', 'log')
  % set(right_y_axis, 'Yscale', 'linear')

end

function order_params = calculate_order_params(temperature, chi_values, tolerance, initial_condition)
  sim = FixedToleranceSimulation(temperature, chi_values, tolerance);
  sim.initial_condition = initial_condition;
  sim = sim.run();
  order_params = sim.compute(OrderParameter);
end
