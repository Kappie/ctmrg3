function calculate_kappa
  width = -0.05;
  temperatures = [Constants.T_crit + width];
  chi_values = 4:1:55;
  % chi_values = [6, 10, 16, 24, 34, 46, 60];
  tolerances = [1e-13];
  beta = 1/8; nu = 1;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances);
  sim = sim.run();
  corr_lengths = sim.compute(CorrelationLengthAfun);

  % [graph_type, slope, intercept] = logfit(chi_values, corr_lengths)
  markerplot(chi_values, corr_lengths, '--')
  [chi_values' corr_lengths']
  xlabel('$\chi$')
  ylabel('$\xi(\chi)$')
  title(['$T = T_c + ' num2str(width) '$'])
  % legend({'data', ['$\kappa$ = ' num2str(slope)]}, 'Location', 'best')



  % xticks(chi_values)
  % slope; %    1.940045384131416
  % METHOD 1: calculate by scaling of correlation length at T_crit
  % number_of_points = 15;
  % number_of_fits = numel(chi_values) - number_of_points;
  % kappa_values = zeros(2, number_of_fits);
  %
  % for index = 1:number_of_fits
  %   [slope1, ~] = logfit(chi_values, order_params, 'loglog', 'skipBegin', index, 'skipEnd', numel(chi_values) - (index + number_of_points));
  %   [slope2, ~] = logfit(chi_values, corr_lengths, 'loglog', 'skipBegin', index, 'skipEnd', numel(chi_values) - (index + number_of_points));
  %   kappa_values(1, index) = -8*slope1;
  %   kappa_values(2, index) = slope2;
  % end


  % markerplot(chi_values(1:number_of_fits), kappa_values);
  % hline(Constants.kappa, '--', '$\kappa_{\mathrm{exact}}$');
  % % hline(total_slope2, '--', )
  % % hline(-8*total_slope1, '--', '$\kappa_{m}$')
  % xlabel('$\chi_{\mathrm{start}}$')
  % ylabel('$\kappa$')
  % legend_labels = {'extracted from $m$', 'extracted from $\xi$'}
  % legend(legend_labels, 'Location', 'best')
end
