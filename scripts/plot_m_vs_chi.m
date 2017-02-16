function plot_m_vs_chi
  temperatures = [Constants.T_crit];
  chi_values = 8:2:112;
  % N_values = [100, 200, 500, 1000, 1500, 2000];
  tolerances = [1e-7];

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances).run();
  % correlation_lengths = sim.compute(CorrelationLengthAfun);
  load('correlation_lengths_chi8-112', 'chi_values', 'correlation_lengths')
  order_params = sim.compute(OrderParameter);

  % beta = 0.125
  % diff_best = 10
  %
  % for skip_begin = 0:1:14
  %   for skip_end = 0:1:14
  %     [slope, intercept] = logfit(correlation_lengths, order_params, 'loglog', 'skipBegin', skip_begin, 'skipEnd', skip_end);
  %     if abs(-slope - beta) < diff_best
  %       beta_best = -slope
  %       best_skip_end = skip_end
  %       best_skip_begin = skip_begin
  %       diff_best = abs(-slope - beta);
  %     end
  %   end
  % end
  % [slope, intercept] = logfit(correlation_lengths, order_params, 'loglog', 'skipBegin', best_skip_begin, 'skipEnd', best_skip_end);

  % markerplot(1./correlation_lengths, order_params, '--')
  xlabel('$\xi(\chi)$')
  ylabel('$m$')
  title(['$\beta / \nu = ' num2str(-slope, 6) '$'])
  % make_legend_tolerances(tolerances)

  % error_estimate_finite_chi(chi_values, order_params)
end
