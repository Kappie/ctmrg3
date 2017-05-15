function compare_correlation_lengths
  q = 2;
  temperature = Constants.T_crit_guess(q);
  chi_values = 8:1:50;
  tolerance = 1e-7;

  % exclude_chi_values = [];
  exclude_chi_values = [8 9 13 19 28 29 40 41 42];
  chi_values_symm = setdiff(chi_values, exclude_chi_values);

  sim_fixed = FixedToleranceSimulation(temperature, chi_values, tolerance, q).run();
  corr_lengths_fixed = sim_fixed.compute('correlation_length');

  sim_symmetric = FixedToleranceSimulation(temperature, chi_values_symm, tolerance, q);
  sim_symmetric.initial_condition = 'symmetric';
  sim_symmetric = sim_symmetric.run();
  corr_lengths_symmetric = sim_symmetric.compute('correlation_length')

  % figure
  % markerplot(chi_values, [corr_lengths_fixed; corr_lengths_symmetric], '--')
  % markerplot(chi_values, [corr_lengths_symmetric], '--')
  % legend({'fixed', 'symmetric'})
  % xlabel('$\chi$')
  % ylabel('$\xi(\chi)$')

  figure
  [kappa_fixed, intercept] = logfit(chi_values, corr_lengths_fixed, 'loglog')
  title(['fixed boundary conditions: $\kappa = ' num2str(kappa_fixed) ' $.'])
  xlabel('$\chi$')
  ylabel('$\xi(\chi)$')

  figure
  [kappa_symm, intercept] = logfit(chi_values_symm, corr_lengths_symmetric, 'loglog')
  title(['Ising model at $T_c$. Symmetric boundary conditions: $\kappa = ' num2str(kappa_symm) ' $.'])
  xlabel('$\chi$')
  ylabel('$\xi(\chi)$')




end
