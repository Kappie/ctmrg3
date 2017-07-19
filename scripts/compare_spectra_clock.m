function compare_spectra_clock
  q = 6;
  temperatures = [0.3 0.8 1.5];
  chi = 100;
  tolerance = 1e-8;
  eigenvalues_to_show = 30;

  sim = FixedToleranceSimulation(temperatures, chi, tolerance, q).run();

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
