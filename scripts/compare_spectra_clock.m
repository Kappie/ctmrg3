function compare_spectra_clock
  q = 5;
  temperatures = [0.4];
  chi = 100;
  tolerance = 1e-7;
  eigenvalues_to_show = 100;

  sim = FixedToleranceSimulation(temperatures, chi, tolerance, q);
  sim.initial_condition = 'symmetric';
  sim = sim.run();

  figure
  hold on
  for t = 1:numel(temperatures)
    eigenvalues = diag(sim.tensors(t).C);
    markerplot(1:eigenvalues_to_show, eigenvalues(1:eigenvalues_to_show), '--', 'semilogy')
  end
  hold off

  set(gca, 'YScale', 'log')
  make_legend(temperatures, 'T')

  % markerplot(1:eigenvalues_to_show, eigenvalues(1:eigenvalues_to_show), '--', 'semilogy')
end
