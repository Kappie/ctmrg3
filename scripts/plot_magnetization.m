function plot_magnetization
  temperatures = Constants.T_crit + [0.2];
  chi_values = [4 8 12 20 30 40 50 60 80 100];
  N_values = [20 40 100 200 400 800 1000 1400 1800 2400];
  tolerances = [1e-7, 1e-15];
  q = 2;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances, q).run();
  order_params_chi = sim.compute('order_parameter')
  % sim.initial_condition = 'symmetric';
  % sim = sim.run();
  % order_params_chi_symmetric = sim.compute('order_parameter');
  %
  sim = FixedTruncationErrorSimulation(temperatures, N_values, 1e-6, q).run();
  order_params_N = sim.compute('order_parameter')
  % sim.initial_condition = 'symmetric';
  % sim = sim.run();
  % order_params_N_symmetric = sim.compute('order_parameter');

  % chi = 40;
  % sim = FixedNSimulation(temperatures, chi, N_values, q).run();
  % order_params = sim.compute('order_parameter');
  % markerplot(N_values, order_params, '--', 'semilogy')
  % figure
  % markerplot(N_values, sim.convergences, '--', 'semilogy')

  markerplot(N_values, [order_params_N], '--', 'semilogy')
  figure
  markerplot(chi_values, [order_params_chi], '--', 'semilogy')
  % make_legend_tolerances(tolerances)


end
