function crossover_between_chi_and_N
  temperature = Constants.T_crit;
  chi_values = [4 10 14 20];
  x_start = 0.3; x_end = 0.65; power = -1/8; number_of_points = 9;
  N_values = rounded_powerspace(power, x_start, x_end, number_of_points);
  % N_values = N_values(1:end-2)

  sim = FixedNSimulation(temperature, chi_values, N_values).run();
  order_params = sim.compute(OrderParameter);

  ctm_length_scales = zeros(1, numel(N_values))


  yyaxis left
  plot(N_values.^(-1/8), order_params)
  yyaxis right
  plot(N_values, sim.convergences)

  % legend_labels = {};
  % for c = 1:numel(chi_values)
  %   legend_labels{end + 1} = ['$\chi = ' num2str(chi_values(c)) '$, convergence = ' num2str(sim.convergences(end, 1))];
  % end
  %
  % legend(legend_labels, 'Location', 'best')

end
