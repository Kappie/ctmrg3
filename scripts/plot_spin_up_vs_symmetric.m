function plot_spin_up_vs_symmetric
  width = 0.05; number_of_points = 9;
  temperatures = Util.linspace_around_T_crit(width, number_of_points);
  chi_values = [8, 16];
  tolerances = [1e-7];

  spin_up_sim = FixedToleranceSimulation(temperatures, chi_values, tolerances).run();
  order_params_spin_up = spin_up_sim.compute(OrderParameter);

  symmetric_sim = FixedToleranceSimulation(temperatures, chi_values, tolerances);
  symmetric_sim.initial_condition = 'symmetric';
  symmetric_sim = symmetric_sim.run();
  order_params_symmetric = symmetric_sim.compute(OrderParameter);

  subplot(2, 1, 1)
  markerplot(temperatures, Util.absolute_relative_error(order_params_spin_up, order_params_symmetric), 'semilogy')
  vline(Constants.T_crit, '--')
  xlabel('$T$')
  ylabel('$|E_{\mathrm{rel}}(m_{\mathrm{symmetric}}, m_{\mathrm{spin-up}})|$')
  make_legend(chi_values, '\chi')

  subplot(2, 1, 2)
  markerplot(temperatures, [order_params_spin_up order_params_symmetric]);
  vline(Constants.T_crit, '--')
  xlabel('$T$')
  ylabel('$m$')
  make_legend(chi_values, '\chi')
  % legend({'spin-up boundary', 'symmetric boundary'}, 'Location', 'best');




end
