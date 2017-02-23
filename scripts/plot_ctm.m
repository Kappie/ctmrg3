function plot_ctm
  q = 2;
  T_crit_guess = Constants.T_crit_guess(q)
  width = 0.1; number_of_points = 3;
  temperatures = linspace(T_crit_guess - width, T_crit_guess + width, number_of_points);
  chi_values = [110];
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
  title('Spectrum of corner transfer matrix of Ising model')
  hold off

end
