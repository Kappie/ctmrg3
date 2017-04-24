function crossover_between_chi_and_N
  q = 2;
  temperature = Constants.T_crit;
  chi_values = [4 8 12 16 20];
  x_start = 0.3; x_end = 0.65; power = -1/8; number_of_points = 20;
  N_values = rounded_powerspace(power, x_start, x_end, number_of_points);
  % N_values = N_values(1:end-2)

  sim = FixedNSimulation(temperature, chi_values, N_values, q).run();
  order_params = sim.compute('order_parameter');

  ctm_length_scales = zeros(1, numel(N_values))


  % yyaxis left
  markerplot(N_values, order_params, '--', 'loglog')
  make_legend(chi_values, '\chi')
  % yyaxis right
  % plot(N_values, sim.convergences)

  % legend_labels = {};
  % for c = 1:numel(chi_values)
  %   legend_labels{end + 1} = ['$\chi = ' num2str(chi_values(c)) '$, convergence = ' num2str(sim.convergences(end, 1))];
  % end
  %
  % legend(legend_labels, 'Location', 'best')

end
