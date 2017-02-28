function plot_ctm
  q = 5;
  temperatures = [0.7 0.95 0.99 1.1]
  chi_values = [40];
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance, q).run();

  number_of_eigenvalues = min(chi_values);

  figure
  hold on
  for t = 1:numel(temperatures)
    C = sim.tensors(t, 1).C;
    plot(diag(C), '--o')
  end

  set(gca, 'YScale', 'log')
  make_legend(temperatures, 'T')
  xlabel('$i$')
  ylabel('$C_i$')
  title('Spectrum of corner transfer matrix of $q = 5$ clock model')
  hold off

end
