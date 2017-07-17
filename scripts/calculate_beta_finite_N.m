function calculate_beta_finite_N
  q = 2;
  temperature = Constants.T_crit_guess(q);
  N_values = [5:5:40 50:10:90 100:100:1000 1250:250:4000];
  chi_values = 2:2:64;
  % chi_values = [2, 3, 4, 5, 6, 7, 9, 11, 13, 15, 18, 21, 24, 28, 33, 38, 43, 49, 56, 64, 72, 81, 92];
  % chi_values = [24, 28, 33, 38, 43, 49, 56, 64, 72, 81, 92];
  % chi_values = chi_values + 2
  tolerance = 1e-7;
  max_truncation_error = 1e-7;
  skipBegin_N = 25;
  skipBegin_chi = 5;
  N_values(skipBegin_N)

  sim_N = FixedTruncationErrorSimulation(temperature, N_values, max_truncation_error, q).run();
  sim_chi = FixedToleranceSimulation(temperature, chi_values, tolerance, q).run();
  figure
  [slope, intersect, mse] = logfit(N_values, sim_N.compute('order_parameter'), 'loglog', ...
    'skipBegin', skipBegin_N)
  title(['$\beta / \nu = ' num2str(-slope, 4) '$'])
  xlabel('$n$')
  ylabel('$M(T = T_c)$')
  % figure
  % [slope, intersect, mse] = logfit(sim_chi.compute('correlation_length'), ...
  % sim_chi.compute('order_parameter'), 'loglog', 'skipBegin', skipBegin_chi)
  % [slope, intersect, mse] = logfit(1./sim_chi.compute('corner_energy_gap'), ...
  %   sim_chi.compute('order_parameter'), 'logy', 'skipBegin', skipBegin)
  % sim_chi.compute('ctm_length_scale');
  % [slope, intersect, mse] = logfit(sim_chi.compute('ctm_length_scale'), sim_chi.compute('order_parameter'), ...
  %   'loglog', 'skipBegin', skipBegin)
  % [slope, intersect, mse] = logfit(12.*sim_chi.compute('entropy'), sim_chi.compute('order_parameter'), ...
  %   'logy', 'skipBegin', skipBegin_chi)
  % title('$\chi$')
  used_chi = numel(chi_values) - skipBegin_chi
  used_N = numel(N_values) - skipBegin_N
end
