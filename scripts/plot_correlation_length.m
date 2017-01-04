function plot_correlation_length
  load('T_pseudocrits_energy_gap20-Dec-2016 13:20:06');
  temperature = Constants.T_crit;
  tolerances = [1e-5, 1e-6, 1e-7, 1e-8];
  chi_indices = [6, 9];
  correlation_lengths = zeros(numel(chi_indices), numel(tolerances));

  for c = chi_indices
    sim = FixedToleranceSimulation(T_pseudocrits(c), chi_values(c), tolerances).run();
    correlation_lengths(c, :) = sim.compute(CorrelationLengthAfun2);
  end

  %
  markerplot(tolerances, correlation_lengths, '--', 'semilogx')
  % hline(Constants.correlation_length(temperature), '--', '$\xi{\mathrm{exact}}$')
  xlabel('tolerance')
  ylabel('$\xi(\chi)$')
  make_legend(chi_values(chi_indices), '\chi')
  title(['$T = ' num2str(T_pseudocrits(chi_indices)) '$'])
  % export_fig(fullfile(Constants.PLOTS_DIR, 'correlation_length_vs_t_tol1e-7_width1e-2.pdf'))
end
