function plot_spin_up_vs_symmetric
  temperatures = Constants.T_pseudocrit(4);
  chi_values = [4];
  N = 2000;

  spin_up_sim = FixedNSimulation(temperatures, chi_values, N).run();
  order_params_spin_up = spin_up_sim.compute(OrderParameter);

  symmetric_sim = FixedNSimulation(temperatures, chi_values, N);
  symmetric_sim.initial_condition = 'symmetric';
  symmetric_sim = symmetric_sim.run();
  order_params_symmetric = symmetric_sim.compute(OrderParameter);

  order_params_symmetric
  order_params_spin_up

  Util.relative_error(order_params_spin_up, order_params_symmetric)


  % subplot(2, 1, 1)
  % markerplot(temperatures, Util.absolute_relative_error(order_params_spin_up, order_params_symmetric), 'semilogy')
  % vline(Constants.T_crit, '--')
  % xlabel('$T$')
  % ylabel('$|E_{\mathrm{rel}}(m_{\mathrm{symmetric}}, m_{\mathrm{spin-up}})|$')
  % make_legend(chi_values, '\chi')
  %
  % subplot(2, 1, 2)
  % markerplot(temperatures, [order_params_spin_up order_params_symmetric]);
  % vline(Constants.T_crit, '--')
  % xlabel('$T$')
  % ylabel('$m$')
  % make_legend(chi_values, '\chi')
  % legend({'spin-up boundary', 'symmetric boundary'}, 'Location', 'best');




end
