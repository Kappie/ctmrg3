function plot_correlation_length
  temperature = Constants.T_crit + [0.1];
  chi_values = [8, 16, 32, 48, 64, 80, 96];
  tolerances = [1e-10];

  sim = FixedToleranceSimulation(temperature, chi_values, tolerances);
  sim = sim.run();
  correlation_lengths = sim.compute(CorrelationLength);

  markerplot(1./chi_values, correlation_lengths, '--')
  hline(Constants.correlation_length(temperature), '--', '$\xi{\mathrm{exact}}$')
  xlabel('$1/\chi$')
  ylabel('$\xi(\chi)$')
  % export_fig(fullfile(Constants.PLOTS_DIR, 'correlation_length_vs_t_tol1e-7_width1e-2.pdf'))
end
